import 'package:flutter/material.dart';
import 'package:caloric/main.dart';

class GenericCard extends StatelessWidget {
  const GenericCard(
      {super.key, required this.child, this.topPadding, this.topRadius});

  final Widget child;
  final double? topPadding;
  final double? topRadius;

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
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 20, left: 20, right: 20),
      child: Card(
        margin: const EdgeInsets.only(top: 0, bottom: 0, left: 4, right: 4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? 10),
              topRight: Radius.circular(topRadius ?? 10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        color: colour,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
            child: child,
          ),
        ),
      ),
    );
  }
}
