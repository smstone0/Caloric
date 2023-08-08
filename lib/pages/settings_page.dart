import 'package:flutter/material.dart';
import '../widgets/grey_card.dart';
import '../databases/settings_database.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        const SettingsCard(
            titles: ["Calorie goal"],
            inputs: [CustomSliderHandler(type: 'Calorie')]),
        const SectionSeparator(),
        const SectionTitle(title: "MEASUREMENTS"),
        const SettingsCard(titles: [
          "Height",
          "Weight",
          "Unit"
        ], inputs: [
          CustomSliderHandler(type: 'Height'),
          CustomSliderHandler(type: 'Weight'),
          SettingsDropdown(list: ["Metric", "Imperial"], type: 'Unit'),
        ]),
        const SectionSeparator(),
        const SectionTitle(title: "STYLE"),
        const SettingsCard(
          titles: ["Dark mode"],
          inputs: [
            SettingsDropdown(list: ["System", "Dark", "Light"], type: 'Mode')
          ],
        )
      ],
    );
  }
}

class CustomSliderHandler extends StatefulWidget {
  const CustomSliderHandler({
    super.key,
    required this.type,
  });

  final String type;

  @override
  State<CustomSliderHandler> createState() => _CustomSliderHandlerState();
}

class _CustomSliderHandlerState extends State<CustomSliderHandler> {
  @override
  Widget build(BuildContext context) {
    double sliderValue;

    return (FutureBuilder<List<Settings>>(
      future: SettingsDatabase().getSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primaryContainer);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Settings> settingsList = snapshot.data ?? [];
          switch (widget.type) {
            case 'Calorie':
              sliderValue = settingsList[0].calorieGoal;
              break;
            case 'Height':
              sliderValue = settingsList[0].height;
              break;
            default:
              sliderValue = settingsList[0].weight;
          }
          return CustomSlider(
            type: widget.type,
            settingsUnit: settingsList[0].unit,
            sliderValue: sliderValue,
            currentSettings: settingsList[0],
          );
        }
      },
    ));
  }
}

class CustomSlider extends StatefulWidget {
  CustomSlider(
      {super.key,
      required this.type,
      required this.settingsUnit,
      required this.sliderValue,
      required this.currentSettings});

  final String type;
  final String settingsUnit;
  double sliderValue;
  Settings currentSettings;

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
        if (widget.settingsUnit == 'Metric') {
          unit = 'cm';
          min = 100;
          max = 250;
        } else {
          unit = 'inches';
          min = 40;
          max = 100;
        }
        break;
      default:
        if (widget.settingsUnit == 'Metric') {
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
                Settings newSettings = widget.currentSettings;
                switch (widget.type) {
                  case 'Calorie':
                    newSettings.calorieGoal = value;
                    break;
                  case 'Height':
                    newSettings.height = value;
                    break;
                  default:
                    newSettings.weight = value;
                }
                SettingsDatabase().updateSettings(newSettings);
              },
            ),
          ],
        ));
  }
}

class SettingsDropdown extends StatefulWidget {
  const SettingsDropdown({super.key, required this.list, required this.type});

  final List<String> list;
  final String type;

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  List<String> getDropdownItems(String type, Settings settingsList) {
    List<String> dropdownItems = [];
    if (type == 'Unit') {
      dropdownItems.add(settingsList.unit);
      for (String item in widget.list) {
        if (item != settingsList.unit) {
          dropdownItems.add(item);
        }
      }
    } else {
      dropdownItems.add(settingsList.mode);
      for (String item in widget.list) {
        if (item != settingsList.mode) {
          dropdownItems.add(item);
        }
      }
    }
    return (dropdownItems);
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems;

    return (FutureBuilder<List<Settings>>(
      future: SettingsDatabase().getSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primaryContainer);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Settings> settingsList = snapshot.data ?? [];
          dropdownItems = getDropdownItems(widget.type, settingsList[0]);
          return Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
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
                    Settings newSettings = settingsList[0];
                    if (widget.type == 'Unit' &&
                        value != settingsList[0].unit) {
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
                        value != settingsList[0].mode) {
                      newSettings.mode = value.toString();
                      //Handle mode change
                      SettingsDatabase().updateSettings(newSettings);
                      //Rebuild page
                    }
                  },
                ),
              ),
            ),
          );
        }
      },
    ));
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
