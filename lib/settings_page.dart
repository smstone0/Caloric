import 'package:flutter/material.dart';
import 'grey_card.dart';

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
        SettingsCard(titles: ["Calorie goal"], inputs: [Text("Placeholder 1")]),
        const SectionSeparator(),
        const SectionTitle(title: "MEASUREMENTS"),
        SettingsCard(titles: [
          "Height",
          "Weight",
          "Unit"
        ], inputs: [
          Text("Placeholder 1"),
          Text("Placeholder 2"),
          SettingsDropdown(
            list: ["Metric", "Imperial"],
          ),
        ]),
        const SectionSeparator(),
        const SectionTitle(title: "STYLE"),
        SettingsCard(
          titles: ["Dark mode"],
          inputs: [
            SettingsDropdown(
              list: ["System", "Dark", "Light"],
            )
          ],
        )
      ],
    );
  }
}

class SettingsDropdown extends StatelessWidget {
  const SettingsDropdown({super.key, required this.list});

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: DropdownButton(
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          //Get
          value: list.first,
          style: DefaultTextStyle.of(context).style,
          dropdownColor: Theme.of(context).colorScheme.primaryContainer,
          underline: Container(
            height: 2,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          onChanged: (String? value) {
            //Set
            print("Placeholder");
          },
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
      child: Text(title, style: const TextStyle(fontSize: 12)),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.titles, required this.inputs});

  final List<String> titles;
  final List<Widget> inputs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GreyCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (String title in titles)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(title),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (Widget input in inputs)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: input,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
