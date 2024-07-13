import 'package:caloric/databases/settings.dart';
import 'package:caloric/main.dart';
import 'package:flutter/material.dart';

import '../pages/settings.dart';

class GenericDropdown<T extends Enum> extends StatefulWidget {
  const GenericDropdown(
      {super.key,
      required this.list,
      required this.selection,
      required this.type,
      required this.settings,
      required this.rebuildPage});

  final List<T> list;
  final T selection;
  final PropertyType type;
  final Settings settings;
  final Function rebuildPage;

  @override
  State<GenericDropdown> createState() => _GenericDropdownState();
}

class _GenericDropdownState extends State<GenericDropdown> {
  //Ensure selection is the first item in dropdown
  List<Enum> orderList(List<Enum> list) {
    if (list[0] != widget.selection) {
      late int index;
      Enum temp;
      for (var i = 0; i < list.length; i++) {
        if (list[i] == widget.selection) {
          index = i;
          break;
        }
      }
      temp = list[0];
      list[0] = list[index];
      list[index] = temp;
    }
    return list;
  }

  String capitalise(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    List<Enum> orderedList = orderList(widget.list.toList());
    Color colour;
    Brightness systemBrightness = MediaQuery.of(context).platformBrightness;
    if (MyApp.of(context)!.getThemeMode() == ThemeMode.light ||
        (MyApp.of(context)!.getThemeMode() == ThemeMode.system &&
            systemBrightness == Brightness.light)) {
      colour = Colors.black;
    } else {
      colour = Colors.white;
    }

    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: SizedBox(
          width: 110,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              selectedItemBuilder: (BuildContext context) {
                return widget.list.map<Widget>((Enum item) {
                  return Center(
                    child: Text(
                      capitalise(widget.selection.name),
                      style: TextStyle(
                        color: colour,
                      ),
                    ),
                  );
                }).toList();
              },
              items: orderedList.map<DropdownMenuItem<Enum>>((Enum value) {
                return DropdownMenuItem<Enum>(
                    value: value,
                    child: Text(capitalise(value.name),
                        style: TextStyle(
                            color: Theme.of(context)
                                        .primaryColor
                                        .computeLuminance() >=
                                    0.5
                                ? Colors.black
                                : Colors.white)));
              }).toList(),
              value: orderedList.first,
              borderRadius: BorderRadius.circular(10),
              style: DefaultTextStyle.of(context).style,
              dropdownColor: Theme.of(context).primaryColor,
              onChanged: (Enum? value) {
                setState(() {});
                Settings newSettings = widget.settings;
                switch (widget.type) {
                  case PropertyType.energy:
                    newSettings.energy.unit = value as EnergyUnit;
                    break;
                  case PropertyType.height:
                    newSettings.height.unit = value as HeightUnit;
                    break;
                  case PropertyType.weight:
                    newSettings.weight.unit = value as WeightUnit;
                    break;
                  case PropertyType.appearance:
                    newSettings.appearance = value as Appearance;
                    MyApp.of(context)!
                        .changeTheme(newSettings.appearance.theme);
                    break;
                }
                SettingsDatabase().updateSettings(newSettings);
                widget.rebuildPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
