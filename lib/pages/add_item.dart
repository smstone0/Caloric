import 'package:caloric/databases/items.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/input_field.dart';
import 'package:flutter/material.dart';
import '../functions/dates.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.settings});

  final Settings settings;

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
                  topPadding: 20,
                  rightPadding: 50,
                  hintText: 'Enter name of item',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    itemName = value;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InputField(
                  keyboardType: TextInputType.number,
                  topPadding: 20,
                  rightPadding: 230,
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
