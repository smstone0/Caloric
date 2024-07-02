import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      this.initialValue,
      this.suffix,
      this.validator,
      this.hintText,
      required this.rightPadding});

  final String? initialValue;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final String? hintText;
  final double rightPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, right: rightPadding),
      child: TextFormField(
        initialValue: initialValue,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal),
          filled: true,
          suffixIcon: suffix,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
