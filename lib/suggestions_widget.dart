import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';
import 'package:speech_box/suggestion_button_widget.dart';

class Suggestions extends StatefulWidget {
  final String filterValue;
  final VoidStringCallBack onSelect;

  Suggestions(this.filterValue, this.onSelect);

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  List<String> suggestions = [
    "Hallo",
    "Hoe gaat het?",
    "Bedankt",
    "Ik",
    "Moemoe",
    "Ik wil",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredSuggestions = List.from(suggestions);

    print(widget.filterValue);

    int _lastSpaceIndex = widget.filterValue.lastIndexOf(" ") == -1
        ? 0
        : widget.filterValue.lastIndexOf(" ");

    String _searchValue = widget.filterValue
        .substring(_lastSpaceIndex, widget.filterValue.length)
        .trim();

    print(_searchValue);

    filteredSuggestions.retainWhere(
        (item) => item.toLowerCase().startsWith(_searchValue.toLowerCase()));

    return ListView.builder(
        itemCount: filteredSuggestions.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: SuggestionButton(
              displayValue: filteredSuggestions[index],
              value: filteredSuggestions[index],
              pressed: widget.onSelect,
              width: 200.0,
            ),
          );
        });
  }
}
