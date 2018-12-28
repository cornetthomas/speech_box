import 'package:flutter/material.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/value_button_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

typedef VoidStringCallBack = void Function(String);

final kKeyboardHeightFactor = 0.7;
final kTextFieldHeightFactor = 0.10;

enum TtsState { Playing, Stopped, Paused }

class ScanningKeyboard extends StatefulWidget {
  ScanningKeyboardState createState() => new ScanningKeyboardState();
}

class ScanningKeyboardState extends State<ScanningKeyboard> {
  String _inputText = "";

  FlutterTts flutterTts;
  TtsState ttsState;

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    ttsState = TtsState.Stopped;

    setupTts();
  }

  Future setupTts() async {
    String _language = "nl-NL";
    double _speechRate = 0.3;
    double _volume = 1.0;
    double _pitch = 1.0;

    try {
      if (await flutterTts.isLanguageAvailable(_language)) {
        await flutterTts.setSpeechRate(_speechRate);

        await flutterTts.setVolume(_volume);

        await flutterTts.setPitch(_pitch);

        print(
            "Language set: $_language, rate: $_speechRate, volume: $_volume, pitch: $_pitch");
      }
    } catch (e) {
      print(e);
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.Playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.Stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.Stopped;
      });
    });
  }

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
                  child: GestureDetector(
                    onTap: () {
                      speakText(_inputText);
                    },
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
                              .copyWith(fontSize: 36.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                ActionButton(
                  displayValue: "Backspace",
                  action: removeLastChar,
                ),
                ActionButton(
                  displayValue: "Clear all",
                  action: clearAllInput,
                ),
                ActionButton(
                  displayValue: "Copy",
                  action: copyToClipboard,
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                buildKeyboard(),
                new ValueButton(
                  displayValue: "Space",
                  value: " ",
                  pressed: updateInputWith,
                  width: MediaQuery.of(context).size.width * 0.6,
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
    "z",
    ".",
    ";",
    "?",
    ":",
    "!"
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

  List<String> suggestions = [
    "hallo",
    "Hoe gaat het",
    "Bedankt",
    "Ik",
    "Dit is een test. Wat vind je er van?"
  ];

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
      _inputText = _inputText.substring(0, _lastSpaceIndex) + " " + value + " ";
    });
  }

  // Actions

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

  void copyToClipboard() {
    Clipboard.setData(new ClipboardData(text: _inputText));
  }

  Future speakText(String text) async {
    if (!(text == null) && !(ttsState == TtsState.Playing)) {
      var result = await flutterTts.speak(text);
      print(result);
      if (result == 1) {
        print("playyed");
      }
    }
  }
}
