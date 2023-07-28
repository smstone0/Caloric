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
        SettingsCard(
            titles: ["Height", "Weight", "Unit"],
            inputs: [Text("Placeholder 2")]),
        const SectionSeparator(),
        const SectionTitle(title: "STYLE"),
        SettingsCard(
          titles: ["Dark mode"],
          inputs: [Text("Placeholder 3")],
        )
      ],
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
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  children: [for (String title in titles) Text(title)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10),
                child: Column(
                  children: inputs,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
