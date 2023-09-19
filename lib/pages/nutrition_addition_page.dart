import 'package:caloric/widgets/grey_card.dart';
import 'package:flutter/material.dart';

class NutritionAdditionPage extends StatelessWidget {
  const NutritionAdditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(
      children: const [
        SizedBox(height: 20),
        GreyCard(
          child: InputCard(),
        ),
      ],
    ));
  }
}

class InputCard extends StatelessWidget {
  const InputCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
          ],
        )
      ],
    );
  }
}
