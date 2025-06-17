import 'package:flutter/material.dart';

class EnergyRing extends StatelessWidget {
  const EnergyRing(
      {super.key,
      required this.size,
      required this.target,
      required this.type,
      required this.energyConsumed});

  final double size;
  final double target;
  final Enum type;
  final int energyConsumed;

  @override
  Widget build(BuildContext context) {
    Color colour = Theme.of(context).primaryColor.computeLuminance() >= 0.5
        ? Colors.black
        : Colors.white;

    double progress = (target != 0) ? (energyConsumed / target) : 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            color: Colors.green,
            strokeWidth: 7,
          ),
        ),
        Positioned(
            child: Column(
          children: [
            Text("$energyConsumed/${target.round()}",
                style: TextStyle(fontSize: 16.5, color: colour)),
            Text(type.name, style: TextStyle(fontSize: 12, color: colour)),
          ],
        )),
      ],
    );
  }
}
