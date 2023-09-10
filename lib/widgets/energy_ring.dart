import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  const CalorieRing(
      {super.key,
      required this.size,
      required this.target,
      required this.type});

  final double size;
  final double target;
  final Enum type;

  @override
  Widget build(BuildContext context) {
    int energy = 50;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: energy / target,
            backgroundColor: Colors.white,
            color: Colors.green,
            strokeWidth: 7,
          ),
        ),
        Text("$energy/${target.round()}",
            style: TextStyle(
                fontSize: 16.5,
                color: Theme.of(context).primaryColor.computeLuminance() >= 0.5
                    ? Colors.black
                    : Colors.white)),
        Text("\n\n${type.name}", style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
