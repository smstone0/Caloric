import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      this.initialValue,
      this.suffix,
      this.validator,
      this.hintText,
      this.rightPadding,
      this.topPadding,
      this.leftPadding,
      this.bottomPadding,
      this.onEditingComplete,
      this.controller,
      required this.keyboardType});

  final String? initialValue;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final String? hintText;
  final double? leftPadding, topPadding, rightPadding, bottomPadding;
  final Function()? onEditingComplete;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding ?? 0, topPadding ?? 0,
          rightPadding ?? 0, bottomPadding ?? 0),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        onEditingComplete: onEditingComplete,
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
