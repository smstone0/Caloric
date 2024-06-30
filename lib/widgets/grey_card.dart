import 'package:flutter/material.dart';
import 'package:caloric/main.dart';

class GreyCard extends StatelessWidget {
  const GreyCard({super.key, required this.child});

  final Widget child;

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
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Card(
            elevation: 0,
            color: colour,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
