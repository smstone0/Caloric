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

enum Sort { oldToNew, newToOld, lowToHigh, highToLow, aToZ, zToA }

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Sort _selectedSort = Sort.newToOld;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle style = DefaultTextStyle.of(context).style;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    return FutureBuilder<List<Item>>(
        future: ItemDatabase().getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Item> items = snapshot.data!;
            return FutureBuilder<Settings>(
                future: SettingsDatabase().getSettings(),
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
                            GenericDropdown<Sort>(
                              list: Sort.values,
                              selection: _selectedSort,
                              onChanged: (value) {
                                //Sort cards
                                _selectedSort = value;
                                setState(() {});
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddItem(settings: settings),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                color: settings.appearance ==
                                            Appearance.light ||
                                        settings.appearance ==
                                                Appearance.system &&
                                            MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.light
                                    ? Colors.black
                                    : const Color.fromRGBO(205, 255, 182, 1)),
                            SizedBox(
                              height: 50,
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
                                onSubmitted: (value) {},
                              ),
                            ),
                          ],
                        )),
                        const SectionSeparator(),
                        if (items.isEmpty)
                          const Text("You have not yet added any items"),
                        ...items.map(
                            (item) => ItemCard(settings: settings, item: item)),
                      ],
                    );
                  }
                });
          }
        });
  }
}
