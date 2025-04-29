import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.widget,
    required this.onPressed,
    required this.colour,
  });

  final Text widget;
  final VoidCallback onPressed;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    Text text = Text(widget.data!,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal));
    return SizedBox(
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
