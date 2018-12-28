import 'package:flutter/material.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/value_button_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

typedef VoidStringCallBack = void Function(String);

final kKeyboardHeightFactor = 0.7;
final kTextFieldHeightFactor = 0.10;
final kKeyboardWidthFactor = 0.8;

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
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        speakText(_inputText);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          border: Border.all(
                            width: 2.0,
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        height: MediaQuery.of(context).size.height *
                            kTextFieldHeightFactor,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
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
                ),
              ],
            ),
          ),
          Container(height: 70.0, child: buildSuggestions()),
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
              Column(
                children: <Widget>[
                  ActionButton(
                    displayValue: "Backspace",
                    action: removeLastChar,
                  ),
                  ActionButton(
                    displayValue: "Wis alles",
                    action: clearAllInput,
                  ),
                  ActionButton(
                    displayValue: "Wis woord",
                    action: clearLastWord,
                  ),
                  ActionButton(
                    displayValue: "Kopiëer",
                    action: copyToClipboard,
                  )
                ],
              )
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
    int axisCount = (keyboardValues.length / 4).ceil().toInt();

    return Container(
      width: MediaQuery.of(context).size.width * kKeyboardWidthFactor,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(5.0),
          itemCount: keyboardValues.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: axisCount),
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
    "Dit is een test. Wat vind je er van?",
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

      Widget _button = Padding(
        padding: const EdgeInsets.all(8.0),
        child: ActionChip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 28.0, color: Colors.black),
            ),
          ),
          onPressed: () {
            updateInputReplace(value);
          },
        ),
      );

      _suggestionButtons.add(_button);
    }

    Widget list = ListView(
      scrollDirection: Axis.horizontal,
      children: _suggestionButtons,
    );

    return list;
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

  void clearLastWord() {
    String currentInput = _inputText.trim();
    int _lastSpaceIndex =
        currentInput.lastIndexOf(" ") == -1 ? 0 : currentInput.lastIndexOf(" ");
    print(_lastSpaceIndex);
    print(currentInput);
    setState(() {
      _inputText = currentInput.substring(0, _lastSpaceIndex);
      print(_inputText);
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
