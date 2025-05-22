import 'package:caloric/databases/items.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/input_field.dart';
import 'package:flutter/material.dart';
import '../functions/dates.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.unit});

  final EnergyUnit unit;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  void initState() {
    super.initState();
  }

  late Unit type;
  String unit = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String itemName;
  late int energy, portion;

  @override
  Widget build(BuildContext context) {
    final unitLabel = widget.unit == EnergyUnit.calories ? 'kcal' : 'kJ';
    final ThemeData theme = Theme.of(context);
    return Material(
        child: ListView(
      children: [
        GenericCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Save new item", style: theme.textTheme.titleMedium),
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
                  hintText: 'Item name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    itemName = value;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text("Enter at least one of the following:",
                    style: theme.textTheme.labelLarge),
                const SizedBox(height: 20),
                Text("By ml/g", style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        keyboardType: TextInputType.number,
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
                    Text('$unitLabel per'),
                    Expanded(
                      child: InputField(
                        keyboardType: TextInputType.number,
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
                Text("Custom", style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        keyboardType: TextInputType.number,
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
                    Text('$unitLabel per'),
                    Expanded(
                      child: InputField(
                        keyboardType: TextInputType.number,
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
                const SizedBox(height: 20),
                CustomButton(
                    colour: theme.primaryColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ItemDatabase().insertItem(Item(
                            itemName: itemName,
                            dateSaved: getCurrentDate(),
                            kcalPer100Unit: 100,
                            unit: Unit.g,
                            customUnitName: "A custom unit",
                            kcalPerCustomUnit: 100));
                      }
                    },
                    widget: const Text("Add"))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
