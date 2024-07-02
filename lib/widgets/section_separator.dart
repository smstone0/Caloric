import 'package:flutter/material.dart';

class SectionSeparator extends StatelessWidget {
  const SectionSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
      child: Container(
        height: 1,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
