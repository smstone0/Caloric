import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.widget,
    required this.onPressed,
    this.isSecondary = false,
  });

  final Text widget;
  final VoidCallback onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final Color primaryColour = Theme.of(context).primaryColor;
    Text text = Text(widget.data!,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.normal));
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSecondary ? primaryColour : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: text,
      ),
    );
  }
}
