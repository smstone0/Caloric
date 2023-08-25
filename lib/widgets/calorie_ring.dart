import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  const CalorieRing({super.key, required this.size, required this.target});

  final double size;
  final double target;

  @override
  Widget build(BuildContext context) {
    int calories = 50;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: calories / target,
            backgroundColor: Colors.white,
            color: Colors.green,
            strokeWidth: 7,
          ),
        ),
        Text("$calories/${target.round()}",
            style: TextStyle(
                fontSize: 16.5,
                color: Theme.of(context).primaryColor.computeLuminance() >= 0.5
                    ? Colors.black
                    : Colors.white)),
      ],
    );
  }
}
