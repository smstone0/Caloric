import 'package:caloric/databases/nutrition.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/grey_card.dart';
import 'package:flutter/material.dart';

/// Add or edit an existing nutrition item

class NutritionInput extends StatefulWidget {
  const NutritionInput(
      {super.key, required this.settings, this.nutrition, required this.id});

  final Settings settings;
  final nutrition;
  final int id;

  @override
  State<NutritionInput> createState() => _NutritionInputState();
}

class _NutritionInputState extends State<NutritionInput> {
  @override
  void initState() {
    super.initState();
    if (!(widget.nutrition == null)) {
      if (widget.nutrition.type == NutType.food) {
        type = NutType.food;
        foodClick = true;
        unit = 'g';
      }
      if (widget.nutrition.type == NutType.drink) {
        type = NutType.drink;
        drinkClick = true;
        unit = 'ml';
      }
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
        const SizedBox(height: 20),
        GreyCard(
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20, bottom: 20, right: 50),
                  child: TextFormField(
                    initialValue: widget.nutrition?.item,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Enter name of item",
                      //hintStyle: DefaultTextStyle.of(context).style,
                      hintStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 2,
                          color: theme.primaryColor,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 4,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item name';
                      }
                      itemName = value;
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
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
                          colour: foodClick == true
                              ? theme.primaryColor
                              : Colors.white,
                          size: Size.small),
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
                          size: Size.small)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 30,
                        child: TextFormField(
                          initialValue: widget.nutrition?.energy.toString(),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: Text(widget.settings.energy.unit ==
                                    EnergyUnit.calories
                                ? 'kcal'
                                : 'kJ'),
                            suffixIconConstraints:
                                const BoxConstraints(minWidth: 0, minHeight: 0),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: theme.primaryColor,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 4,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            var val = int.tryParse(value!);
                            if (val is int) {
                              energy = val;
                              return null;
                            }
                            return 'error';
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text("per "),
                    SizedBox(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        initialValue: widget.nutrition?.quantity.toString(),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          suffixIcon: Text(unit),
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              color: theme.primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 4,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
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
                ElevatedButton(
                    //TODO: Update main nutrition page
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
                    child: widget.nutrition == null
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
