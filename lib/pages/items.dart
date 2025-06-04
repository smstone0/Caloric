import 'package:caloric/pages/add_item.dart';
import 'package:caloric/widgets/generic_card.dart';
import 'package:caloric/widgets/section_separator.dart';
import 'package:flutter/material.dart';
import 'package:caloric/widgets/heading.dart';
import 'package:flutter/services.dart';
import 'package:caloric/databases/items.dart';
import 'package:caloric/databases/settings.dart';
import 'package:caloric/widgets/generic_dropdown.dart';
import '../widgets/item_card.dart';
import 'package:caloric/functions/item_sorting.dart';

enum Sort { oldToNew, newToOld, lowToHigh, highToLow, aToZ, zToA }

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  void initState() {
    super.initState();
    _items = ItemDatabase().getItems();
    _settings = SettingsDatabase().getSettings();
  }

  Sort _selectedSort = Sort.newToOld;
  bool _removeSelected = false;
  late Future<List<Item>> _items;
  late Future<Settings> _settings;
  String _searchValue = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle style = DefaultTextStyle.of(context).style;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    return FutureBuilder<List<Item>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Item> items = snapshot.data!;
            items = getSortedItems(items, _selectedSort);
            if (_searchValue.isNotEmpty) {
              items = items
                  .where((item) => item.itemName
                      .toLowerCase()
                      .trim()
                      .contains(_searchValue.toLowerCase().trim()))
                  .toList();
            }
            return FutureBuilder<Settings>(
                future: _settings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                          CircularProgressIndicator(color: theme.primaryColor),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Settings settings = snapshot.data!;
                    return ListView(
                      children: [
                        const Heading(text: "Nutrition"),
                        GenericCard(
                            child: Wrap(
                          runSpacing: 5,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericDropdown<Sort>(
                                  list: Sort.values,
                                  selection: _selectedSort,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSort = value;
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _removeSelected
                                            ? Color(0xFFE58B8B)
                                            : null,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.remove, size: 18),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() {
                                            _removeSelected = !_removeSelected;
                                          });
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => AddItem(
                                                unit: settings.energy.unit),
                                          ),
                                        )
                                            .then((value) {
                                          setState(() {
                                            _items = ItemDatabase().getItems();
                                          });
                                        });
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 45,
                              child: TextField(
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "Search for item",
                                  hintStyle: style,
                                  prefixIcon: const Icon(Icons.search),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(45),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(45),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchValue = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                        const SectionSeparator(),
                        if (items.isEmpty)
                          Center(
                            child:
                                const Text("You have not yet added any items"),
                          ),
                        ...items.map((item) => ItemCard(
                            settings: settings,
                            item: item,
                            removeSelected: _removeSelected,
                            onRemove: () {
                              setState(() {
                                _items = ItemDatabase().getItems();
                              });
                            })),
                      ],
                    );
                  }
                });
          }
        });
  }
}
