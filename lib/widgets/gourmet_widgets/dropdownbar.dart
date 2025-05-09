import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class DropdownBar extends StatefulWidget {
  final List<String>? items;
  final String hintText;
  final void Function(String) onChanged;

  const DropdownBar({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<DropdownBar> createState() => _DropdownBarState();
}

class _DropdownBarState extends State<DropdownBar> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButton<String>(
        hint: Text(
          widget.hintText,
          style: const TextStyle(color: primaryColor, fontSize: 12),
        ),
        style: const TextStyle(
          color: primaryColor,
          fontSize: 12,
        ),
        value: value,
        isExpanded: true,
        iconSize: 25,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: widget.items?.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            alignment: Alignment.center,
            child: Text(item),
          );
        }).toList(),
        underline: Container(),
        onChanged: (value) {
          setState(() => this.value = value);
          widget.onChanged(value!);
        },
      ),
    );
  }
}
