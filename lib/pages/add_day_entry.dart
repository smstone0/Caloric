import 'package:caloric/databases/day_entry.dart';
import 'package:caloric/databases/items.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/custom_button.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/generic_dropdown.dart';
import 'package:caloric/widgets/input_field.dart';
import 'package:caloric/widgets/item_card.dart';
import 'package:flutter/material.dart';

enum TabType { quickAddition, chooseFromItems }

class AddDayEntry extends StatefulWidget {
  const AddDayEntry(
      {super.key,
      required this.unit,
      required this.date,
      required this.displayDate});

  final EnergyUnit unit;
  final String date;
  final String displayDate;

  @override
  State<AddDayEntry> createState() => _AddDayEntryState();
}

class _AddDayEntryState extends State<AddDayEntry> {
  @override
  void initState() {
    super.initState();
    _items = ItemDatabase().getItems();
    _settings = SettingsDatabase().getSettings();
  }

  late Future<List<Item>> _items;
  late Future<Settings> _settings;
  late Unit type;
  String unit = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TabType _tabType = TabType.chooseFromItems;
  final TextEditingController _loggedNameController = TextEditingController();
  final TextEditingController _loggedEnergyController = TextEditingController();
  final TextEditingController _loggedAmountController = TextEditingController();
  String _selectedLoggedUnit = "";
  List<String> _selectedUnits = [];
  Item? _selectedItem;

  bool _isValidInput() {
    return _loggedNameController.text.trim().isNotEmpty &&
        _loggedEnergyController.text.trim().isNotEmpty;
  }

  int calculateTotalKcal(double amount) {
    int total = 0;
    if (_selectedItem == null) return total;
    if (_selectedLoggedUnit != 'g' && _selectedLoggedUnit != 'ml') {
      total = (amount * (_selectedItem!.kcalPerCustomUnit ?? 0)).round();
    } else {
      total = ((amount / 100) * (_selectedItem!.kcalPer100Unit ?? 0)).round();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = widget.unit == EnergyUnit.calories ? 'kcal' : 'kJ';
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Log Item for ${widget.displayDate}",
              style: theme.textTheme.titleMedium),
        ),
        body: ListView(
          children: [
            GenericCard(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomButton(
                          widget: Text('Choose from items'),
                          onPressed: () {
                            setState(() {
                              _tabType = TabType.chooseFromItems;
                            });
                          },
                          isSecondary: !(_tabType == TabType.chooseFromItems),
                        ),
                        // SizedBox(
                        //   width: 15,
                        // ),
                        CustomButton(
                          widget: Text('Quick addition'),
                          onPressed: () {
                            setState(() {
                              _tabType = TabType.quickAddition;
                            });
                          },
                          isSecondary: !(_tabType == TabType.quickAddition),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Visibility(
                          visible: _tabType == TabType.quickAddition,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputField(
                                width: 150,
                                keyboardType: TextInputType.text,
                                hintText: 'Item name',
                                controller: _loggedNameController,
                              ),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: InputField(
                                      keyboardType: TextInputType.number,
                                      hintText: '0',
                                      controller: _loggedEnergyController,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(unitLabel),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _tabType == TabType.chooseFromItems,
                          child: FutureBuilder<Settings>(
                            future: _settings,
                            builder: (context, settingsSnapshot) {
                              if (settingsSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: theme.primaryColor),
                                );
                              } else if (settingsSnapshot.hasError) {
                                return Text('Error: ${settingsSnapshot.error}');
                              } else {
                                final settings = settingsSnapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<List<Item>>(
                                      future: _items,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: theme.primaryColor),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          List<Item> items = snapshot.data!;
                                          return Column(
                                            children: [
                                              //TODO: Search, add and filter
                                              if (items.isEmpty)
                                                const Center(
                                                  child: Text(
                                                      "You have not yet added any items"),
                                                ),
                                              ...items.map(
                                                (item) => GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedItem = item;
                                                      _selectedUnits =
                                                          ItemDatabase()
                                                              .getUnits(item);
                                                      _selectedLoggedUnit =
                                                          _selectedUnits[0];
                                                    });
                                                  },
                                                  child: ItemCard(
                                                    settings: settings,
                                                    item: item,
                                                    isSelected:
                                                        item == _selectedItem,
                                                  ),
                                                ),
                                              ),
                                              //TODO: Above is scrollable, below is static
                                              SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: InputField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      hintText: '0',
                                                      controller:
                                                          _loggedAmountController,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: _selectedUnits
                                                        .isNotEmpty,
                                                    child:
                                                        GenericDropdown<String>(
                                                      capitalise: false,
                                                      list: _selectedUnits,
                                                      selection:
                                                          _selectedLoggedUnit,
                                                      onChanged:
                                                          (String value) {
                                                        setState(() {
                                                          _selectedLoggedUnit =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomButton(
                              onPressed: () {
                                double? amount = double.tryParse(
                                    _loggedAmountController.text.trim());
                                String itemName =
                                    _loggedNameController.text.trim();
                                int? energy = int.tryParse(
                                    _loggedEnergyController.text.trim());

                                if (_tabType == TabType.chooseFromItems) {
                                  if (_selectedItem == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 3500),
                                        backgroundColor: theme.primaryColor,
                                        content: Text(
                                            'Please select an item from the list'),
                                      ),
                                    );
                                    return;
                                  }
                                  if (amount == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 3500),
                                        backgroundColor: theme.primaryColor,
                                        content: Text(
                                            'Please enter an amount for the item'),
                                      ),
                                    );
                                    return;
                                  }

                                  DayEntryDatabase().insertDayEntry(
                                    DayEntry(
                                      dateLogged: widget.date,
                                      itemName: _selectedItem!.itemName,
                                      totalKcal: calculateTotalKcal(
                                          amount), //TODO: Calculate energy from item amount against per 100 kcal or per portion
                                      amount: amount,
                                      recordedByUnit: _selectedLoggedUnit,
                                    ),
                                  );
                                } else {
                                  if (!_isValidInput()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration:
                                            const Duration(milliseconds: 3500),
                                        backgroundColor: theme.primaryColor,
                                        content: Text(
                                            'Please fill in an item name and an energy value'),
                                      ),
                                    );
                                    return;
                                  }

                                  DayEntryDatabase().insertDayEntry(
                                    DayEntry(
                                      dateLogged: widget.date,
                                      itemName: itemName,
                                      totalKcal: energy ?? 0,
                                    ),
                                  );
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      backgroundColor: theme.primaryColor,
                                      content:
                                          Text('Item added successfully!')),
                                );

                                _loggedNameController.clear();
                                _loggedEnergyController.clear();
                                _loggedAmountController.clear();
                                _selectedLoggedUnit = "";
                                _selectedUnits.clear();
                              },
                              widget: const Text("Add")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
