import 'package:flutter/material.dart';
import 'package:uridachi/l10n/app_localizations.dart';

class EmailInputField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> domainOptions;
  final String selectedDomain;
  final Function(String) onDomainChanged;

  const EmailInputField({
    super.key,
    required this.controller,
    required this.domainOptions,
    required this.selectedDomain,
    required this.onDomainChanged,
  });

  @override
  _EmailInputFieldState createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        SizedBox(width: screenWidth * 0.002427 * 8),
        const Text(
          "@",
          style:
              TextStyle(color: Color(0xff582AB2), fontWeight: FontWeight.bold),
        ),
        SizedBox(width: screenWidth * 0.002427 * 8),
        Expanded(
          flex: 2,
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFF89949F)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.002427 * 30.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: widget.selectedDomain,
                onChanged: (newValue) {
                  setState(() {
                    widget.onDomainChanged(newValue!);
                  });
                },
                items: widget.domainOptions.map((domain) {
                  return DropdownMenuItem<String>(
                    value: domain,
                    child: Text(
                      domain,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
