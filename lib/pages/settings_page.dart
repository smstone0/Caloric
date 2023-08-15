import 'package:flutter/material.dart';
import '../widgets/grey_card.dart';
import '../databases/settings_database.dart';
import '../widgets/custom_button.dart';

String capitalise(String text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double getHeight(Settings settings) {
    if (settings.unit == Unit.metric) {
      return settings.height.cm;
    } else {
      return settings.height.inches;
    }
  }

  double getWeight(Settings settings) {
    if (settings.unit == Unit.metric) {
      return settings.weight.kg;
    } else {
      return settings.weight.lbs;
    }
  }

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
                "Unit system",
                "Height unit",
                "Weight unit"
              ], inputs: [
                CustomSlider(
                    type: 'Height',
                    settings: settings,
                    sliderValue: getHeight(settings)),
                CustomSlider(
                    type: 'Weight',
                    settings: settings,
                    sliderValue: getWeight(settings)),
                SettingsDropdown(
                    list: const ["Metric", "Imperial"],
                    type: 'Unit',
                    settings: settings,
                    rebuildPage: () {
                      setState(() {});
                    }),
                UnitButtons(
                    type: 'height',
                    settings: settings,
                    rebuildPage: () {
                      setState(() {});
                    }),
                UnitButtons(
                    type: 'weight',
                    settings: settings,
                    rebuildPage: () {
                      setState(() {});
                    }),
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "STYLE"),
              SettingsCard(
                titles: const ["Light/dark mode"],
                inputs: [
                  SettingsDropdown(
                      list: const ["System", "Dark", "Light"],
                      type: 'Mode',
                      settings: settings,
                      rebuildPage: () {
                        setState(() {});
                      })
                ],
              )
            ],
          );
        }
      },
    );
  }
}

class UnitButtons extends StatelessWidget {
  const UnitButtons(
      {super.key,
      required this.type,
      required this.settings,
      required this.rebuildPage});

  final String type;
  final Settings settings;
  final Function rebuildPage;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    Color colour = Theme.of(context).colorScheme.primaryContainer;

    Color buttonColour(Object button) {
      if (button == settings.imperialHeight ||
          button == settings.imperialWeight ||
          button == settings.metricHeight) {
        return colour;
      } else {
        return Colors.white;
      }
    }

    if (type == 'height') {
      if (settings.unit == Unit.metric) {
        buttons = [
          CustomButton(
            text: 'm',
            onPressed: () {
              settings.metricHeight = MetricHeight.m;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(MetricHeight.m),
            height: 30,
            width: 80,
          ),
          CustomButton(
            text: 'cm',
            onPressed: () {
              settings.metricHeight = MetricHeight.cm;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(MetricHeight.cm),
            height: 30,
            width: 80,
          )
        ];
      } else {
        buttons = [
          CustomButton(
            text: 'ft in',
            onPressed: () {
              settings.imperialHeight = ImperialHeight.ftinches;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(ImperialHeight.ftinches),
            height: 30,
            width: 90,
          ),
          CustomButton(
            text: 'in',
            onPressed: () {
              settings.imperialHeight = ImperialHeight.inches;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(ImperialHeight.inches),
            height: 30,
            width: 90,
          )
        ];
      }
    } else {
      if (settings.unit == Unit.metric) {
        buttons = [
          CustomButton(
            text: 'kg',
            // Kg is the only metric weight option, therefore a settings update and rebuild is not required
            onPressed: () {},
            colour: colour,
            height: 30,
            width: 80,
          )
        ];
      } else {
        buttons = [
          CustomButton(
            text: 'lbs',
            onPressed: () {
              settings.imperialWeight = ImperialWeight.lbs;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(ImperialWeight.lbs),
            height: 30,
            width: 90,
          ),
          CustomButton(
            text: 'st lbs',
            onPressed: () {
              settings.imperialWeight = ImperialWeight.stonelbs;
              SettingsDatabase().updateSettings(settings);
              rebuildPage();
            },
            colour: buttonColour(ImperialWeight.stonelbs),
            height: 30,
            width: 90,
          )
        ];
      }
    }

    return Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: buttons);
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
  String feetAndInches(double value) {
    double inch = value % 12;
    double feet = (value - inch) / 12;

    return "${feet.round()}'${inch.round()}\"";
  }

  String stonesAndPounds(double value) {
    double pounds = value % 14;
    double stones = (value - pounds) / 14;
    return "${stones.round()}st ${pounds.round()}lbs";
  }

  @override
  Widget build(BuildContext context) {
    double min, max;
    int divisions;
    String label = widget.sliderValue.round().toString();

    switch (widget.type) {
      case 'Calorie':
        label = '$label kcal';
        min = 1000;
        max = 10000;
        break;
      case 'Height':
        if (widget.settings.unit == Unit.metric) {
          min = widget.settings.height.cmMin;
          max = widget.settings.height.cmMax;
          if (widget.settings.metricHeight == MetricHeight.m) {
            label = '${(widget.sliderValue / 100).toStringAsFixed(2)}m';
          } else {
            label = '$label${widget.settings.metricHeight.name}';
          }
        } else {
          min = widget.settings.height.inchMin;
          max = widget.settings.height.inchMax;
          if (widget.settings.imperialHeight == ImperialHeight.ftinches) {
            label = feetAndInches(widget.sliderValue);
          } else {
            label = '$label ${widget.settings.imperialHeight.name}';
          }
        }
        break;
      default:
        if (widget.settings.unit == Unit.metric) {
          label = '${label}kg';
          min = widget.settings.weight.kgMin;
          max = widget.settings.weight.kgMax;
        } else {
          min = widget.settings.weight.lbsMin;
          max = widget.settings.weight.lbsMax;
          if (widget.settings.imperialWeight == ImperialWeight.stonelbs) {
            label = stonesAndPounds(widget.sliderValue);
          } else {
            label = '$label${widget.settings.imperialWeight.name}';
          }
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
                label,
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
                    if (widget.settings.unit == Unit.metric) {
                      newSettings.height.cm = value;
                    } else {
                      newSettings.height.inches = value;
                    }
                    break;
                  default:
                    if (widget.settings.unit == Unit.metric) {
                      newSettings.weight.kg = value;
                    } else {
                      newSettings.weight.lbs = value;
                    }
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
      required this.settings,
      required this.rebuildPage});

  final List<String> list;
  final String type;
  final Settings settings;
  final Function rebuildPage;

  @override
  State<SettingsDropdown> createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  List<String> getDropdownItems() {
    List<String> dropdownItems = [];
    if (widget.type == 'Unit') {
      dropdownItems.add(capitalise(widget.settings.unit.name));
      for (String item in widget.list) {
        if (item != capitalise(widget.settings.unit.name)) {
          dropdownItems.add(item);
        }
      }
    } else {
      dropdownItems.add(capitalise(widget.settings.appearance.name));
      for (String item in widget.list) {
        if (item != capitalise(widget.settings.appearance.name)) {
          dropdownItems.add(item);
        }
      }
    }
    return (dropdownItems);
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = getDropdownItems();

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
              if (widget.type == 'Unit' &&
                  value!.toLowerCase() != widget.settings.unit.name) {
                switch (value) {
                  case "Metric":
                    newSettings.unit = Unit.metric;
                    break;
                  default:
                    newSettings.unit = Unit.imperial;
                }
                SettingsDatabase().updateSettings(newSettings);
                widget.rebuildPage();
              } else if (widget.type == 'Mode' &&
                  value!.toLowerCase() != widget.settings.appearance.name) {
                switch (value) {
                  case "System":
                    newSettings.appearance = Appearance.system;
                    break;
                  case "Dark":
                    newSettings.appearance = Appearance.dark;
                    break;
                  default:
                    newSettings.appearance = Appearance.light;
                }
                SettingsDatabase().updateSettings(newSettings);
                widget.rebuildPage();
              }
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 300) {
            return Column(
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
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 20),
                        child: inputs[i],
                      )
                    ],
                  ),
              ],
            );
          } else {
            return Column(
              children: [
                for (int i = 0; i < titles.length; i++)
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(titles[i]),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: inputs[i])
                  ]),
              ],
            );
          }
        },
      ),
    );
  }
}
