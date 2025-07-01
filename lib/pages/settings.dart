import 'package:caloric/main.dart';
import 'package:caloric/widgets/generic_dropdown.dart';
import 'package:caloric/widgets/input_field.dart';
import 'package:caloric/widgets/section_title.dart';
import 'package:caloric/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();
    _settings = SettingsDatabase().getSettings();
  }

  late Future<Settings> _settings;
  TextEditingController energyController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface));
    return FutureBuilder<Settings>(
      future: _settings,
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
          energyController = TextEditingController(
              text: settings.energy.value.round().toString());
          heightController = TextEditingController(
              text: settings.height.value.round().toString());
          weightController = TextEditingController(
              text: settings.weight.value.round().toString());
          return ListView(
            children: [
              const Heading(text: "Settings"),
              const SectionTitle(title: "TARGET"),
              SettingsCard(children: [
                (
                  "Energy Goal",
                  Row(
                    children: [
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
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(settings.energy.unit == EnergyUnit.calories
                          ? 'kcal'
                          : 'kJ')
                    ],
                  ),
                ),
                (
                  "Energy Unit",
                  GenericDropdown<EnergyUnit>(
                    list: EnergyUnit.values,
                    selection: settings.energy.unit,
                    onChanged: (newUnit) {
                      settings.energy.unit = newUnit;
                      SettingsDatabase().updateSettings(settings);
                      setState(() {});
                    },
                    displayLabel: (value) {
                      return value == EnergyUnit.calories
                          ? "Calories"
                          : "Joules";
                    },
                  ),
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
                  GenericDropdown<HeightUnit>(
                    list: HeightUnit.values,
                    selection: settings.height.unit,
                    onChanged: (newUnit) {
                      settings.height.unit = newUnit;
                      SettingsDatabase().updateSettings(settings);
                      setState(() {});
                    },
                    displayLabel: (value) {
                      switch (value) {
                        case HeightUnit.centimetres:
                          return "Centimetres";
                        case HeightUnit.metres:
                          return "Metres";
                        case HeightUnit.feet:
                          return "Feet";
                        case HeightUnit.inches:
                          return "Inches";
                      }
                    },
                  ),
                ),
                (
                  "Weight",
                  Expanded(
                    child: InputField(
                      //TODO: Handle stone
                      controller: weightController,
                      keyboardType: TextInputType.number,
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
                  GenericDropdown<WeightUnit>(
                    list: WeightUnit.values,
                    selection: settings.weight.unit,
                    onChanged: (newUnit) {
                      settings.weight.unit = newUnit;
                      SettingsDatabase().updateSettings(settings);
                      setState(() {});
                    },
                    displayLabel: (value) {
                      return value.name;
                    },
                  ),
                )
              ]),
              const SectionSeparator(),
              const SectionTitle(title: "STYLE"),
              SettingsCard(
                children: [
                  (
                    "Light/Dark Mode",
                    GenericDropdown<Appearance>(
                      list: Appearance.values,
                      selection: settings.appearance,
                      onChanged: (newUnit) {
                        settings.appearance = newUnit;
                        SettingsDatabase().updateSettings(settings);
                        MyApp.of(context)!
                            .changeTheme(settings.appearance.theme);
                        setState(() {});
                      },
                      displayLabel: (value) {
                        return value.name;
                      },
                    ),
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
