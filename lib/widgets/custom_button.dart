import 'package:flutter/material.dart';

enum Size { small, medium, large }

double getHeight(Size size) {
  switch (size) {
    case Size.small:
      return 40;
    case Size.medium:
      return 50;
    default:
      return 38;
  }
}

double getWidth(Size size) {
  switch (size) {
    case Size.small:
      return 85;
    case Size.medium:
      return 105;
    default:
      return 190;
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.widget,
      required this.onPressed,
      required this.colour,
      required this.size});

  final Text widget;
  final VoidCallback onPressed;
  final Color colour;
  final Size size;

  @override
  Widget build(BuildContext context) {
    Text text = Text(widget.data!,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal));
    return SizedBox(
      height: getHeight(size),
      width: getWidth(size),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: text,
      ),
    );
  }
}
