import 'package:caloric/widgets/grey_card.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<(String, Widget)> children;

  @override
  Widget build(BuildContext context) {
    return GreyCard(
      topPadding: 5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 300) {
            return Column(
                children: children.map<Widget>((value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value.$1),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: value.$2,
                  )
                ],
              );
            }).toList());
          } else {
            return Column(
              children: children.map<Widget>((value) {
                return Column(children: [
                  //TODO: Test paddings on small screen
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
