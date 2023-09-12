import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: 5,
          child: Container(
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
