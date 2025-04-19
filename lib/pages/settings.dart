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
                  GenericDropdown<EnergyUnit>(
                    list: EnergyUnit.values,
                    selection: settings.energy.unit,
                    onChanged: (newUnit) {
                      settings.energy.unit = newUnit;
                      SettingsDatabase().updateSettings(settings);
                      setState(() {});
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
                    GenericDropdown<HeightUnit>(
                      list: HeightUnit.values,
                      selection: settings.height.unit,
                      onChanged: (newUnit) {
                        settings.height.unit = newUnit;
                        SettingsDatabase().updateSettings(settings);
                        setState(() {});
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
                    GenericDropdown<WeightUnit>(
                      list: WeightUnit.values,
                      selection: settings.weight.unit,
                      onChanged: (newUnit) {
                        settings.weight.unit = newUnit;
                        SettingsDatabase().updateSettings(settings);
                        setState(() {});
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
