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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customEnergyController = TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  Unit selectedUnit = Unit.g;

  bool _isValidInput() {
    if (_nameController.text.trim().isEmpty) return false;
    final hasByUnit = _energyController.text.trim().isNotEmpty &&
        _amountController.text.trim().isNotEmpty;
    final hasCustom = _customEnergyController.text.trim().isNotEmpty &&
        _customUnitController.text.trim().isNotEmpty;
    return hasByUnit || hasCustom;
  }

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
                      controller: _nameController,
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
                            controller: _energyController,
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
                            controller: _amountController,
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
                            controller: _customEnergyController,
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
                            controller: _customUnitController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                          onPressed: () {
                            String itemName = _nameController.text.trim();
                            int? energy =
                                int.tryParse(_energyController.text.trim());
                            int? amount =
                                int.tryParse(_amountController.text.trim());
                            int? customEnergy = int.tryParse(
                                _customEnergyController.text.trim());
                            String? customUnitName =
                                _customUnitController.text.trim();
                            if (!_isValidInput()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 3500),
                                  backgroundColor: theme.primaryColor,
                                  content: Text(
                                      'Please fill in an item name and at least one energy field'),
                                ),
                              );
                              return;
                            }
                            int? kcalPer100Unit;
                            if (energy != null &&
                                amount != null &&
                                amount > 0) {
                              kcalPer100Unit =
                                  ((energy / amount) * 100).round();
                            } else {
                              kcalPer100Unit = null;
                            }
                            //TODO: Fix bug where half a pair added (e.g. missing unit count but grams added) if validation passes
                            ItemDatabase().insertItem(
                              Item(
                                  itemName: itemName,
                                  dateSaved: getStringCurrentDate(),
                                  kcalPer100Unit: kcalPer100Unit,
                                  unit: selectedUnit,
                                  customUnitName: customUnitName,
                                  kcalPerCustomUnit: customEnergy),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: const Duration(milliseconds: 1500),
                                  backgroundColor: theme.primaryColor,
                                  content: Text('Item added successfully!')),
                            );

                            _nameController.clear();
                            _energyController.clear();
                            _amountController.clear();
                            _customEnergyController.clear();
                            _customUnitController.clear();
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
