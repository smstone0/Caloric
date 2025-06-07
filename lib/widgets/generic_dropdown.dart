import 'package:flutter/material.dart';

class GenericDropdown<T> extends StatefulWidget {
  const GenericDropdown({
    super.key,
    required this.list,
    required this.selection,
    required this.onChanged,
    this.capitalise = true,
    this.displayLabel,
  });

  final List<T> list;
  final T selection;
  final ValueChanged<T> onChanged;
  final bool capitalise;
  final String Function(T)? displayLabel;

  @override
  State<GenericDropdown<T>> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T> extends State<GenericDropdown<T>> {
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
    final words = text
        .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (match) => ' ')
        .split(' ');
    return words
        .map((word) =>
            "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
        .join(' ');
  }

  String display(T item) {
    final label = widget.displayLabel?.call(item) ?? item.toString();
    return widget.capitalise ? capitalise(label) : label;
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: orderedList.first,
            borderRadius: BorderRadius.circular(10),
            dropdownColor: theme.primaryColor,
            selectedItemBuilder: (context) {
              return orderedList.map((item) {
                return Center(
                  child: Text(
                    display(item),
                    style: TextStyle(color: baseColor),
                  ),
                );
              }).toList();
            },
            items: orderedList.map((value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  display(value),
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
    );
  }
}
