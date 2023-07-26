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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: SizedBox(
            height: 5,
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Text("TARGET", style: TextStyle(fontSize: 12)),
        ),
        const GreyCard(
          child: Text("Placeholder"),
        ),
      ],
    );
  }
}
