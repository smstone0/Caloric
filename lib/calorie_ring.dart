import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  const CalorieRing({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    int calories = 50;
    int target = 2000;

    double value = calories / target;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              backgroundColor: Colors.white,
              color: Colors.green,
              strokeWidth: 7,
            ),
          ),
          Text("$calories/$target", style: const TextStyle(fontSize: 16.5)),
        ],
      ),
    );
  }
}
