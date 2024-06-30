import 'package:flutter/material.dart';

Color getColourBMI(double bmi) {
  switch (bmi) {
    case < 18.5:
      return Colors.blue;
    case < 25:
      return Colors.green;
    case < 30:
      return Colors.orange;
    default:
      return Colors.red;
  }
}
