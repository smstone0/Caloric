import 'package:caloric/databases/nutrition.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/input_field.dart';
import 'package:flutter/material.dart';

/// Add or edit an existing nutrition item

class NutritionInput extends StatefulWidget {
  const NutritionInput(
      {super.key, required this.settings, this.nutrition, required this.id});

  final Settings settings;
  final Nutrition? nutrition;
  final int id;

  @override
  State<NutritionInput> createState() => _NutritionInputState();
}

class _NutritionInputState extends State<NutritionInput> {
  @override
  void initState() {
    super.initState();
    if (widget.nutrition?.type == NutType.food) {
      type = NutType.food;
      foodClick = true;
      unit = 'g';
    }
    if (widget.nutrition?.type == NutType.drink) {
      type = NutType.drink;
      drinkClick = true;
      unit = 'ml';
    }
  }

  bool foodClick = false;
  bool drinkClick = false;
  late NutType type;
  String unit = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String itemName;
  late int energy, portion;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
        child: ListView(
      children: [
        GenericCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.nutrition == null ? "Add item" : "Edit item",
                        style: theme.textTheme.titleMedium),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                InputField(
                  keyboardType: TextInputType.text,
                  topPadding: 20,
                  rightPadding: 50,
                  hintText: 'Enter name of item',
                  initialValue: widget.nutrition?.item,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    itemName = value;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CustomButton(
                      widget: const Text("Food"),
                      onPressed: () {
                        setState(() {
                          foodClick = true;
                          drinkClick = false;
                          type = NutType.food;
                          unit = 'g';
                        });
                      },
                      colour:
                          foodClick == true ? theme.primaryColor : Colors.white,
                    ),
                    const SizedBox(width: 5),
                    CustomButton(
                      widget: const Text("Drink"),
                      onPressed: () {
                        setState(() {
                          drinkClick = true;
                          foodClick = false;
                          type = NutType.drink;
                          unit = 'ml';
                        });
                      },
                      colour: drinkClick == true
                          ? theme.primaryColor
                          : Colors.white,
                    )
                  ],
                ),
                InputField(
                  keyboardType: TextInputType.number,
                  topPadding: 20,
                  rightPadding: 230,
                  initialValue: widget.nutrition?.energy.toString(),
                  suffix: Text(
                      widget.settings.energy.unit == EnergyUnit.calories
                          ? 'kcal'
                          : 'kJ'),
                  validator: (value) {
                    var val = int.tryParse(value!);
                    if (val is int) {
                      energy = val;
                      return null;
                    }
                    return 'error';
                  },
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, right: 5),
                      child: Text("per "),
                    ),
                    Flexible(
                      child: InputField(
                        keyboardType: TextInputType.number,
                        topPadding: 20,
                        rightPadding: 200,
                        suffix: Text(unit),
                        initialValue: widget.nutrition?.quantity.toString(),
                        validator: (value) {
                          var val = int.tryParse(value!);
                          if (val is int) {
                            portion = val;
                            return null;
                          }
                          return 'error';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                    //TODO: Update main nutrition page
                    colour: theme.primaryColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate() && foodClick ||
                          drinkClick) {
                        DateTime time = DateTime.now();
                        NutritionDatabase().insertNutrition(Nutrition(
                            id: widget.id,
                            item: itemName,
                            energy: energy,
                            type: type,
                            quantity: portion,
                            unit: unit,
                            creationDate:
                                '${time.day}/${time.month}/${time.year}'));
                      }
                    },
                    widget: widget.nutrition == null
                        ? const Text("Add")
                        : const Text("Edit"))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
