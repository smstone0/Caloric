import 'package:caloric/databases/items.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/generic_dropdown.dart';
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
  late String itemName, customUnitName;
  late int energy, amount, customEnergy;
  Unit selectedUnit = Unit.g;

  @override
  Widget build(BuildContext context) {
    final unitLabel = widget.unit == EnergyUnit.calories ? 'kcal' : 'kJ';
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Save new item", style: theme.textTheme.titleMedium),
        ),
        body: ListView(
          children: [
            GenericCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    InputField(
                      width: 150,
                      keyboardType: TextInputType.text,
                      hintText: 'Item name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        itemName = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Text("Enter at least one of the following:",
                        style: theme.textTheme.labelLarge),
                    const SizedBox(height: 10),
                    Text("By ml/g", style: theme.textTheme.titleMedium),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: InputField(
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              var val = int.tryParse(value!);
                              if (val is int) {
                                energy = val;
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text('$unitLabel per'),
                        ),
                        SizedBox(
                          width: 60,
                          child: InputField(
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              var val = int.tryParse(value!);
                              if (val is int) {
                                amount = val;
                                return null;
                              }
                            },
                          ),
                        ),
                        GenericDropdown<Unit>(
                          capitalise: false,
                          list: Unit.values,
                          selection: selectedUnit,
                          onChanged: (value) {
                            setState(() {
                              selectedUnit = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Custom", style: theme.textTheme.titleMedium),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: InputField(
                            keyboardType: TextInputType.number,
                            hintText: '0',
                            validator: (value) {
                              var val = int.tryParse(value!);
                              if (val is int) {
                                customEnergy = val;
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text('$unitLabel per'),
                        ),
                        SizedBox(
                          width: 150,
                          child: InputField(
                            keyboardType: TextInputType.text,
                            hintText: 'custom name',
                            validator: (value) {
                              if (!(value == null || value.isEmpty)) {
                                customUnitName = value;
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                          colour: theme.primaryColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ItemDatabase().insertItem(
                                Item(
                                    itemName: itemName,
                                    dateSaved: getCurrentDate(),
                                    kcalPer100Unit: energy,
                                    unit: selectedUnit,
                                    customUnitName: customUnitName,
                                    kcalPerCustomUnit: customEnergy),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Item added successfully!')),
                              );

                              _formKey.currentState!.reset();
                            }
                          },
                          widget: const Text("Add")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
