import 'package:flutter/material.dart';

class GreyCard extends StatelessWidget {
  const GreyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Card(
        elevation: 0,
        color: const Color.fromRGBO(217, 217, 217, 175),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: child,
          ),
        ),
      ),
    );
  }
}
