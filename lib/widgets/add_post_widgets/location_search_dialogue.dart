import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:uridachi/l10n/app_localizations.dart';
import '../../utils/colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;

  const CustomTextFormField({super.key, required this.controller});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  var uuid = Uuid();
  final String _sessionToken = '11223344';
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    getSuggestion(widget.controller.text);
  }

  void getSuggestion(String input) async {
    if (mounted) {
      String apiKey = "your api key";
      String baseURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String components = "country:JP";
      String request =
          "$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken&components=$components";

      var response = await http.get(Uri.parse(request));
      var data = response.body.toString();

      print(data);

      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _placesList = jsonDecode(response.body.toString())['predictions'];
          });
        } else {
          throw Exception('Failed to load data');
        }
      }
    }
  }

  void onPredictionItemClick(String prediction) {
    FocusScope.of(context).unfocus();
    widget.controller.text = prediction;
    setState(() {
      _placesList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: localization.search,
              labelStyle: TextStyle(color: primaryColor)),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _placesList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_placesList[index]['description']),
              onTap: () {
                onPredictionItemClick(_placesList[index]['description']);
              },
            );
          },
        ),
      ],
    );
  }
}
