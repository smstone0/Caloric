import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.widget,
      required this.onPressed,
      required this.colour,
      required this.height,
      required this.width});

  final Widget widget;
  final VoidCallback onPressed;
  final Color colour;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    Widget finalWidget = widget;
    if (widget is Text) {
      Text text = widget as Text;
      finalWidget = Text(
        text.data!,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      );
    }
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: finalWidget,
      ),
    );
  }
}
