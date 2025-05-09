import 'package:flutter/material.dart';

class DropdownBarLoc extends StatefulWidget {
  final List<String>? items;
  final String hintText;

  const DropdownBarLoc(
      {super.key, required this.items, required this.hintText});

  @override
  State<DropdownBarLoc> createState() => _DropdownBarLocState();
}

class _DropdownBarLocState extends State<DropdownBarLoc> {
  String? value;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.001093 * 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
      child: DropdownButton<String>(
        dropdownColor: Colors.grey[300],
        alignment: Alignment.center,
        hint: Text(
          widget.hintText,
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: const TextStyle(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
        value: value,
        isExpanded: true,
        iconSize: 25,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        items: widget.items?.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            alignment: Alignment.center,
            child: Text(item),
          );
        }).toList(),
        underline: Container(),
        onChanged: (value) => setState(() => this.value = value),
      ),
    );
  }
}
