import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  const CalorieRing({super.key, required this.size});

  final double size;
  final int calories = 0;
  final int target = 2000;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
                child: Text("$calories/$target",
                    style: const TextStyle(fontSize: 16.5))),
          ),
        ),
      ),
    );
  }
}
