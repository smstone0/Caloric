import 'package:flutter/material.dart';
import '../widgets/grey_card.dart';
import '../databases/settings_database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Settings>(
      future: SettingsDatabase().getSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primaryContainer),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Settings settings = snapshot.data!;
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 15),
                child: Text("Settings", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 5,
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: "TARGET"),
              SettingsCard(titles: const [
                "Calorie goal"
              ], inputs: [
                CustomSlider(
                    type: 'Calorie',
                    settings: settings,
                    sliderValue: settings.calorieGoal)
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "MEASUREMENTS"),
              SettingsCard(titles: const [
                "Height",
                "Weight",
                "Unit"
              ], inputs: [
                CustomSlider(
                    type: 'Height',
                    settings: settings,
                    sliderValue: settings.height),
                CustomSlider(
                    type: 'Weight',
                    settings: settings,
                    sliderValue: settings.weight),
                SettingsDropdown(
                    list: const ["Metric", "Imperial"],
                    type: 'Unit',
                    settings: settings),
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "STYLE"),
              SettingsCard(
                titles: const ["Light/dark mode"],
                inputs: [
                  SettingsDropdown(
                      list: const ["System", "Dark", "Light"],
                      type: 'Mode',
                      settings: settings)
                ],
              )
            ],
          );
        }
      },
    );
  }
}

class CustomSlider extends StatefulWidget {
  CustomSlider(
      {super.key,
      required this.type,
      required this.settings,
      required this.sliderValue});

  final String type;
  final Settings settings;
  double sliderValue;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    double min, max;
    int divisions;
    String unit;

    switch (widget.type) {
      case 'Calorie':
        unit = 'kcal';
        min = 1000;
        max = 10000;
        break;
      case 'Height':
        if (widget.settings.unit == 'Metric') {
          unit = 'cm';
          min = 100;
          max = 250;
        } else {
          unit = ' inches';
          min = 40;
          max = 100;
        }
        break;
      default:
        if (widget.settings.unit == 'Metric') {
          unit = 'kg';
          min = 35;
          max = 275;
        } else {
          unit = 'lbs';
          min = 80;
          max = 600;
        }
    }
    if (widget.type == 'Calorie') {
      divisions = 180;
    } else {
      divisions = (max - min).round();
    }

    return Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.sliderValue.round().toString() + unit,
              ),
            ),
            Slider(
              value: widget.sliderValue,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: Theme.of(context).colorScheme.primaryContainer,
              onChanged: (double value) {
                setState(() {
                  widget.sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                Settings newSettings = widget.settings;
                switch (widget.type) {
                  case 'Calorie':
                    newSettings.calorieGoal = value;
                    break;
                  case 'Height':
                    //
                    newSettings.height = value;
                    //
                    break;
                  default:
                    //
                    newSettings.weight = value;
                  //
                }
                SettingsDatabase().updateSettings(newSettings);
              },
            ),
          ],
        ));
  }
}

class SettingsDropdown extends StatefulWidget {
  const SettingsDropdown(
      {super.key,
      required this.list,
      required this.type,
      required this.settings});

  final List<String> list;
  final String type;
  final Settings settings;

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  List<String> getDropdownItems(String type, Settings settings) {
    List<String> dropdownItems = [];
    if (type == 'Unit') {
      dropdownItems.add(settings.unit);
      for (String item in widget.list) {
        if (item != settings.unit) {
          dropdownItems.add(item);
        }
      }
    } else {
      dropdownItems.add(settings.mode);
      for (String item in widget.list) {
        if (item != settings.mode) {
          dropdownItems.add(item);
        }
      }
    }
    return (dropdownItems);
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = getDropdownItems(widget.type, widget.settings);

    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: dropdownItems.first,
            style: DefaultTextStyle.of(context).style,
            dropdownColor: Theme.of(context).colorScheme.primaryContainer,
            onChanged: (String? value) {
              setState(() {});
              Settings newSettings = widget.settings;
              //
              if (widget.type == 'Unit' && value != widget.settings.unit) {
                newSettings.unit = value.toString();
                //Handle unit conversion for height and weight
                if (value == 'Metric') {
                  //Convert from imperial to metric
                  newSettings.height = newSettings.height * 2.54;
                  newSettings.weight = newSettings.weight / 2.205;
                } else if (value == 'Imperial') {
                  //Convert from metric to imperial
                  newSettings.height = newSettings.height / 2.54;
                  newSettings.weight = newSettings.weight * 2.205;
                }
                SettingsDatabase().updateSettings(newSettings);
                //Rebuild page
              } else if (widget.type == 'Mode' &&
                  value != widget.settings.mode) {
                newSettings.mode = value.toString();
                //Handle mode change
                SettingsDatabase().updateSettings(newSettings);
                //Rebuild page
              }
              //
            },
          ),
        ),
      ),
    );
  }
}

class SectionSeparator extends StatelessWidget {
  const SectionSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        height: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
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
  const SettingsCard({super.key, required this.titles, required this.inputs});

  final List<String> titles;
  final List<Widget> inputs;

  @override
  Widget build(BuildContext context) {
    return GreyCard(
      child: Column(
        children: [
          for (int i = 0; i < titles.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(titles[i]),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                  child: inputs[i],
                )
              ],
            ),
        ],
      ),
    );
  }
}
