import 'package:flutter/material.dart';

class DropdownBarRound extends StatefulWidget {
  final List<String>? items;
  final String hintText;

  const DropdownBarRound(
      {super.key, required this.items, required this.hintText});

  @override
  State<DropdownBarRound> createState() => _DropdownBarRoundState();
}

class _DropdownBarRoundState extends State<DropdownBarRound> {
  String? value;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.001093 * 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.black),
      child: DropdownButton<String>(
        dropdownColor: Colors.black,
        alignment: Alignment.center,
        hint: Text(
          widget.hintText,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        value: value,
        isExpanded: true,
        iconSize: 25,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
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
