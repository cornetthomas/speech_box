import 'package:flutter/material.dart';
import 'package:speech_box/value_button_widget.dart';

typedef VoidStringCallBack = void Function(String);

final kKeyboardHeightFactor = 0.7;
final kTextFieldHeightFactor = 0.15;

class ScanningKeyboard extends StatefulWidget {
  ScanningKeyboardState createState() => new ScanningKeyboardState();
}

class ScanningKeyboardState extends State<ScanningKeyboard> {
  String _inputText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    height: MediaQuery.of(context).size.height *
                        kTextFieldHeightFactor,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        _inputText,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 22.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FlatButton(
                    color: Colors.black12,
                    onPressed: () {
                      removeLastChar();
                    },
                    child: new Text("Backspace"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FlatButton(
                    color: Colors.black12,
                    onPressed: () {
                      clearAllInput();
                    },
                    child: new Text("Clear all"),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(children: [
                buildKeyboard(),
                new ValueButton(
                  displayValue: "Space",
                  value: " ",
                  pressed: updateInputWith,
                ),
              ]),
            ],
          ),
          Row(
            children: <Widget>[
              buildSuggestions(),
            ],
          ),
        ],
      ),
    );
  }

  List<String> keyboardValues = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z"
  ];

  Widget buildKeyboard() {
    return Container(
      color: Colors.red,
      width: MediaQuery.of(context).size.width * kKeyboardHeightFactor,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(5.0),
          itemCount: keyboardValues.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ValueButton(
                displayValue: keyboardValues[index],
                value: keyboardValues[index],
                pressed: updateInputWith,
              ),
            );
          }),
    );
  }

  List<String> suggestions = ["hallo", "Hoe gaat het", "Bedankt", "Ik"];

  Widget buildSuggestions() {
    List<Widget> _suggestionButtons = [];

    List<String> filteredSuggestions = List.from(suggestions);

    int _lastSpaceIndex =
        _inputText.lastIndexOf(" ") == -1 ? 0 : _inputText.lastIndexOf(" ");

    String _searchValue =
        _inputText.substring(_lastSpaceIndex, _inputText.length).trim();

    filteredSuggestions.retainWhere(
        (item) => item.toLowerCase().startsWith(_searchValue.toLowerCase()));

    for (String suggestion in filteredSuggestions) {
      String value = suggestion;

      ValueButton _button = ValueButton(
          value: value, displayValue: value, pressed: updateInputReplace);

      _suggestionButtons.add(_button);
    }

    return Row(children: _suggestionButtons);
  }

  // Input field manipulation methods

  void updateInputWith(String value) {
    setState(() {
      _inputText += value;
    });
  }

  void updateInputReplace(String value) {
    int _lastSpaceIndex =
        _inputText.lastIndexOf(" ") == -1 ? 0 : _inputText.lastIndexOf(" ");
    setState(() {
      String _searchValue = _inputText =
          _inputText.substring(0, _lastSpaceIndex) + " " + value + " ";
    });
  }

  void removeLastChar() {
    int maxIndex = _inputText.length - 1 > 0 ? _inputText.length - 1 : 0;

    setState(() {
      _inputText = _inputText.substring(0, maxIndex);
    });
  }

  void clearAllInput() {
    setState(() {
      _inputText = "";
    });
  }
}
