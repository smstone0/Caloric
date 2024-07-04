import 'package:flutter/material.dart';
import 'package:caloric/main.dart';

class GreyCard extends StatelessWidget {
  const GreyCard({super.key, required this.child, this.topPadding});

  final Widget child;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    Color colour;
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    if (MyApp.of(context)!.getThemeMode() == ThemeMode.light ||
        (MyApp.of(context)!.getThemeMode() == ThemeMode.system &&
            systemBrightness == Brightness.light)) {
      colour = const Color.fromRGBO(217, 217, 217, 0.25);
    } else {
      colour = const Color.fromRGBO(217, 217, 217, 0.1);
    }
    return Column(
      children: [
        SizedBox(
          height: topPadding ?? 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Card(
            elevation: 0,
            color: colour,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
