import 'package:caloric/widgets/input_field.dart';
import 'package:caloric/widgets/section_title.dart';
import 'package:caloric/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
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
        statusBarColor: Theme.of(context).colorScheme.surface));
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
          TextEditingController energyController = TextEditingController(
              text: settings.energy.value.round().toString());
          TextEditingController heightController = TextEditingController(
              text: settings.height.value.round().toString());
          TextEditingController weightController = TextEditingController(
              text: settings.weight.value.round().toString());
          return ListView(
            children: [
              const Heading(text: "Settings"),
              const SectionTitle(title: "TARGET"),
              SettingsCard(children: [
                (
                  "Energy Goal",
                  Expanded(
                    child: InputField(
                        keyboardType: TextInputType.number,
                        controller: energyController,
                        onEditingComplete: () {
                          //TODO: Collapse tray, set to min/max if exceeded
                          var energy = double.tryParse(energyController.text);
                          if (energy is double) {
                            settings.energy.value = energy;
                            SettingsDatabase().updateSettings(settings);
                          }
                        },
                        leftPadding: 150,
                        //TODO: Suffix
                        suffix: Text(settings.energy.unit == EnergyUnit.calories
                            ? 'kcal'
                            : 'kJ')),
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
                  Builder(builder: (context) {
                    if (settings.height.unit == HeightUnit.feet) {
                      // return Row(
                      //   children: [
                      //     Expanded(child: InputField()),
                      //     Expanded(
                      //       child: InputField(),
                      //     )
                      //   ],
                      // );
                      return const Text("Placeholder");
                    }
                    return Expanded(
                      child: InputField(
                        //TODO: Handle metres
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        leftPadding: 150,
                        onEditingComplete: () {
                          var height = double.tryParse(heightController.text);
                          if (height is double) {
                            settings.height.value = height;
                            SettingsDatabase().updateSettings(settings);
                          }
                        },
                        //TODO: Suffix
                      ),
                    );
                  }),
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
                  Expanded(
                    child: InputField(
                      //TODO: Handle stone
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      leftPadding: 150,
                      onEditingComplete: () {
                        var weight = double.tryParse(weightController.text);
                        if (weight is double) {
                          settings.weight.value = weight;
                          SettingsDatabase().updateSettings(settings);
                        }
                      },
                      //TODO: Suffix
                    ),
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
      color: Theme.of(context).colorScheme.surface,
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
