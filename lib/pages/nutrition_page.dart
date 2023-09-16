import 'package:flutter/material.dart';
import 'package:caloric/widgets/heading.dart';
import 'package:flutter/services.dart';
import 'package:caloric/databases/nutrition_database.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background));
    return FutureBuilder<List<Nutrition>>(
        future: NutritionDatabase().getNutrition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Nutrition> nutrition = snapshot.data!;
            return ListView(
              children: const [
                Heading(text: "Nutrition"),
              ],
            );
          }
        });
  }
}
