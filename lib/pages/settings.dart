import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../widgets/grey_card.dart';
import '../databases/settings.dart';
import '../widgets/heading.dart';
import 'package:caloric/widgets/section_separator.dart';

enum PropertyType { energy, height, weight, appearance }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background));
    return FutureBuilder<Settings>(
      future: SettingsDatabase().getSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Settings settings = snapshot.data!;
          return ListView(
            children: [
              const Heading(text: "Settings"),
              const SectionTitle(title: "TARGET"),
              SettingsCard(children: [
                (
                  "Energy Goal",
                  SettingsSlider(
                    settings: settings,
                    measurement: settings.energy,
                  ),
                ),
                (
                  "Energy Unit",
                  SettingsDropdown(
                      list: EnergyUnit.values,
                      selection: settings.energy.unit,
                      type: PropertyType.energy,
                      settings: settings,
                      rebuildPage: () {
                        setState(() {});
                      }),
                )
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "MEASUREMENTS"),
              SettingsCard(children: [
                (
                  "Height",
                  SettingsSlider(
                    settings: settings,
                    measurement: settings.height,
                  ),
                ),
                (
                  "Height Unit",
                  SettingsDropdown(
                      list: HeightUnit.values,
                      selection: settings.height.unit,
                      type: PropertyType.height,
                      settings: settings,
                      rebuildPage: () {
                        setState(() {});
                      }),
                ),
                (
                  "Weight",
                  SettingsSlider(
                    settings: settings,
                    measurement: settings.weight,
                  ),
                ),
                (
                  "Weight Unit",
                  SettingsDropdown(
                      list: WeightUnit.values,
                      selection: settings.weight.unit,
                      type: PropertyType.weight,
                      settings: settings,
                      rebuildPage: () {
                        setState(() {});
                      }),
                )
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "STYLE"),
              SettingsCard(
                children: [
                  (
                    "Light/Dark Mode",
                    SettingsDropdown<Appearance>(
                        list: Appearance.values,
                        selection: settings.appearance,
                        type: PropertyType.appearance,
                        settings: settings,
                        rebuildPage: () {})
                  )
                ],
              )
            ],
          );
        }
      },
    );
  }
}

class SettingsSlider extends StatefulWidget {
  final Settings settings;
  final Measurement measurement;

  const SettingsSlider({
    super.key,
    required this.settings,
    required this.measurement,
  });

  @override
  State<SettingsSlider> createState() => _SettingsSliderState();
}

class _SettingsSliderState extends State<SettingsSlider> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.background,
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.measurement.toString(),
              ),
            ),
            Slider(
              value: widget.measurement.value,
              min: widget.measurement.min,
              max: widget.measurement.max,
              divisions: widget.measurement.divisions,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).cardColor,
              onChanged: (double value) {
                setState(() {
                  widget.measurement.value = value;
                });
              },
              onChangeEnd: (value) {
                widget.measurement.value = value;
                SettingsDatabase().updateSettings(widget.settings);
              },
            ),
          ],
        ));
  }
}

class SettingsDropdown<T extends Enum> extends StatefulWidget {
  const SettingsDropdown(
      {super.key,
      required this.list,
      required this.selection,
      required this.type,
      required this.settings,
      required this.rebuildPage});

  final List<T> list;
  final T selection;
  final PropertyType type;
  final Settings settings;
  final Function rebuildPage;

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  //Ensure selection is the first item in dropdown
  List<Enum> orderList(List<Enum> list) {
    if (list[0] != widget.selection) {
      late int index;
      Enum temp;
      for (var i = 0; i < list.length; i++) {
        if (list[i] == widget.selection) {
          index = i;
          break;
        }
      }
      temp = list[0];
      list[0] = list[index];
      list[index] = temp;
    }
    return list;
  }

  String capitalise(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    List<Enum> orderedList = orderList(widget.list.toList());
    Color colour;
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    if (MyApp.of(context)!.getThemeMode() == ThemeMode.light ||
        (MyApp.of(context)!.getThemeMode() == ThemeMode.system &&
            systemBrightness == Brightness.light)) {
      colour = Colors.black;
    } else {
      colour = Colors.white;
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          width: 110,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              selectedItemBuilder: (BuildContext context) {
                return widget.list.map<Widget>((Enum item) {
                  return Center(
                    child: Text(
                      capitalise(widget.selection.name),
                      style: TextStyle(
                        color: colour,
                      ),
                    ),
                  );
                }).toList();
              },
              items: orderedList.map<DropdownMenuItem<Enum>>((Enum value) {
                return DropdownMenuItem<Enum>(
                    value: value,
                    child: Text(capitalise(value.name),
                        style: TextStyle(
                            color: Theme.of(context)
                                        .primaryColor
                                        .computeLuminance() >=
                                    0.5
                                ? Colors.black
                                : Colors.white)));
              }).toList(),
              value: orderedList.first,
              style: DefaultTextStyle.of(context).style,
              dropdownColor: Theme.of(context).primaryColor,
              onChanged: (Enum? value) {
                setState(() {});
                Settings newSettings = widget.settings;
                switch (widget.type) {
                  case PropertyType.energy:
                    newSettings.energy.unit = value as EnergyUnit;
                    break;
                  case PropertyType.height:
                    newSettings.height.unit = value as HeightUnit;
                    break;
                  case PropertyType.weight:
                    newSettings.weight.unit = value as WeightUnit;
                    break;
                  case PropertyType.appearance:
                    newSettings.appearance = value as Appearance;
                    MyApp.of(context)!
                        .changeTheme(newSettings.appearance.theme);
                    break;
                }
                SettingsDatabase().updateSettings(newSettings);
                widget.rebuildPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Text(title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<(String, Widget)> children;

  @override
  Widget build(BuildContext context) {
    return GreyCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 300) {
            return Column(
                children: children.map<Widget>((value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(value.$1),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                    child: value.$2,
                  )
                ],
              );
            }).toList());
          } else {
            return Column(
              children: children.map<Widget>((value) {
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(value.$1),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: value.$2)
                ]);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
