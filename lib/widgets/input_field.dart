import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      this.initialValue,
      this.validator,
      this.hintText,
      this.onEditingComplete,
      this.controller,
      this.width,
      required this.keyboardType});

  final String? initialValue;
  final String? Function(String?)? validator;
  final String? hintText;
  final Function()? onEditingComplete;
  final TextEditingController? controller;
  final double? width;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.8,
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
