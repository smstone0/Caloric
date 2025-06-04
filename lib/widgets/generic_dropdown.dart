import 'package:flutter/material.dart';

class GenericDropdown<T extends Enum> extends StatefulWidget {
  const GenericDropdown({
    super.key,
    required this.list,
    required this.selection,
    required this.onChanged,
    this.capitalise = true,
  });

  final List<T> list;
  final T selection;
  final ValueChanged<T> onChanged;
  final bool capitalise;

  @override
  State<GenericDropdown<T>> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T extends Enum> extends State<GenericDropdown<T>> {
  // Ensure selection is the first item in dropdown
  List<T> orderList(List<T> list) {
    if (list[0] != widget.selection) {
      final index = list.indexOf(widget.selection);
      final temp = list[0];
      list[0] = list[index];
      list[index] = temp;
    }
    return list;
  }

  String capitalise(String text) {
    // Split text by camel case and capitalize each word
    final words = text
        .replaceAllMapped(
          RegExp(r'(?<=[a-z])(?=[A-Z])'),
          (match) => ' ',
        )
        .split(' ');

    return words
        .map((word) =>
            "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    List<T> orderedList = orderList(widget.list.toList());
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isLight = brightness == Brightness.light;
    final baseColor = isLight ? Colors.black : Colors.white;

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: orderedList.first,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: theme.primaryColor,
              selectedItemBuilder: (context) {
                return orderedList.map((item) {
                  return Center(
                    child: Text(
                      widget.capitalise ? capitalise(item.name) : item.name,
                      style: TextStyle(color: baseColor),
                    ),
                  );
                }).toList();
              },
              items: orderedList.map((value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    widget.capitalise ? capitalise(value.name) : value.name,
                    style: TextStyle(
                      color: theme.primaryColor.computeLuminance() >= 0.5
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {});
                  widget.onChanged(value);
                }
              },
              style: DefaultTextStyle.of(context).style,
            ),
          ),
        ),
      ),
    );
  }
}
