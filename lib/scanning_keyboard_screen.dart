import 'package:flutter/material.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/icon_board_screen.dart';
import 'package:speech_box/speech_input_widget.dart';
import 'package:speech_box/suggestion_button_widget.dart';
import 'package:speech_box/suggestions_widget.dart';
import 'package:speech_box/value_button_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

typedef VoidStringCallBack = void Function(String);

final kKeyboardHeightFactor = 0.55;
final kTextFieldHeightFactor = 0.10;
final kKeyboardWidthFactor = 0.8;

enum TtsState { Playing, Stopped, Paused }
enum KeyBoardState { Letters, Numbers, Sentences }

class ScanningKeyboard extends StatefulWidget {
  ScanningKeyboardState createState() => new ScanningKeyboardState();
}

class ScanningKeyboardState extends State<ScanningKeyboard> {
  String _inputText = "";

  var inputNotifier;

  FlutterTts flutterTts;
  TtsState ttsState;
  List<String> keyboardValues;
  KeyBoardState keyBoardState;
  List<String> _savedSentences = [];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<Widget> gridElements = List<Widget>();

  @override
  void initState() {
    super.initState();

    inputNotifier = ValueNotifier<String>(_inputText);

    flutterTts = FlutterTts();
    ttsState = TtsState.Stopped;

    keyBoardState = KeyBoardState.Letters;

    setupTts();

    _getSentences().then((sentences) {
      setState(() {
        if (sentences != null) {
          _savedSentences = sentences;
        }
      });
    });
  }

  Future setupTts() async {
    String _language = "nl-NL";
    double _speechRate = 0.35;
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
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ValueListenableBuilder<String>(
                valueListenable: inputNotifier,
                builder: (context, value, _) {
                  print("rebuild");
                  return SpeechInput(value, speakText);
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.10,
                child: ValueListenableBuilder<String>(
                  valueListenable: inputNotifier,
                  builder: (context, value, _) {
                    print("rebuild suggestions");
                    return Suggestions(value, updateInputReplace);
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: " ",
                    displayValue: "SPATIE",
                    pressed: updateInputWith,
                    height: 80.0,
                    width: 200.0,
                  ),
                  ActionButton(
                    displayValue: "WIS",
                    action: removeLastChar,
                  ),
                  ActionButton(
                    displayValue: "Wis",
                    action: clearLastWord,
                  ),
                  ActionButton(
                    displayValue: "Wis alles",
                    action: clearAllInput,
                  ),
                  ActionButton(
                    displayValue: "Kopiëer",
                    action: copyToClipboard,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: "e",
                    displayValue: "e",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "n",
                    displayValue: "n",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "t",
                    displayValue: "t",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "d",
                    displayValue: "d",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "g",
                    displayValue: "g",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "j",
                    displayValue: "j",
                    pressed: updateInputWith,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: "a",
                    displayValue: "a",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "i",
                    displayValue: "i",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "r",
                    displayValue: "r",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "h",
                    displayValue: "h",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "v",
                    displayValue: "v",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "c",
                    displayValue: "c",
                    pressed: updateInputWith,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: "o",
                    displayValue: "o",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "l",
                    displayValue: "l",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "k",
                    displayValue: "k",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "w",
                    displayValue: "w",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "f",
                    displayValue: "f",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: ",",
                    displayValue: ",",
                    pressed: updateInputWith,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: "s",
                    displayValue: "s",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "u",
                    displayValue: "u",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "z",
                    displayValue: "z",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "x",
                    displayValue: "x",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: ".",
                    displayValue: ".",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "m",
                    displayValue: "m",
                    pressed: updateInputWith,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ValueButton(
                    value: "b",
                    displayValue: "b",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "y",
                    displayValue: "y",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "?",
                    displayValue: "?",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "!",
                    displayValue: "!",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "p",
                    displayValue: "p",
                    pressed: updateInputWith,
                  ),
                  ValueButton(
                    value: "q",
                    displayValue: "q",
                    pressed: updateInputWith,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ActionButton(
                    displayValue: "Zin opslaan",
                    color: Colors.white70,
                    action: () {
                      setState(() {
                        _savedSentences.add(_inputText);
                        _saveSentences();
                      });
                    },
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  List<String> numberValues = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];

  Widget buildSentencesList() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: ListView.builder(
            itemCount: _savedSentences.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    border: Border.all(
                      width: 2.0,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _savedSentences[index],
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 40.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      speakText(_savedSentences[index]);
                    },
                  ),
                ),
              );
            }));
  }

  List<String> suggestions = [
    "Hallo",
    "Hoe gaat het?",
    "Bedankt",
    "Ik",
    "Moemoe",
    "Ik wil",
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
        padding: const EdgeInsets.all(4.0),
        child: SuggestionButton(
          displayValue: value,
          value: value,
          pressed: updateInputReplace,
        ),
      );

      _suggestionButtons.add(_button);
    }

    Widget list = Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _suggestionButtons,
      ),
    );

    return list;
  }

  // Input field manipulation methods

  void updateInputWith(String value) {
    setState(() {
      _inputText += value;
      inputNotifier.value = _inputText;
    });
  }

  void updateInputReplace(String value) {
    int _lastSpaceIndex =
        _inputText.lastIndexOf(" ") == -1 ? 0 : _inputText.lastIndexOf(" ");
    setState(() {
      _inputText = _inputText.substring(0, _lastSpaceIndex) + " " + value + " ";
      inputNotifier.value = _inputText;
    });
  }

  void clearLastWord() {
    String currentInput = _inputText.trim();
    int _lastSpaceIndex =
        currentInput.lastIndexOf(" ") == -1 ? 0 : currentInput.lastIndexOf(" ");

    setState(() {
      _inputText = currentInput.substring(0, _lastSpaceIndex);
      inputNotifier.value = _inputText;
    });
  }

  // Actions

  void removeLastChar() {
    int maxIndex = _inputText.length - 1 > 0 ? _inputText.length - 1 : 0;

    setState(() {
      _inputText = _inputText.substring(0, maxIndex);
      inputNotifier.value = _inputText;
    });
  }

  void clearAllInput() {
    setState(() {
      _inputText = "";
      inputNotifier.value = _inputText;
    });
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _inputText));
  }

  Future speakText(String text) async {
    print("Should speak");
    if (!(text == null) && !(ttsState == TtsState.Playing)) {
      print("Ok, to speak");
      setState(() {
        ttsState = TtsState.Playing;
      });

      var result = await flutterTts.speak(text);
      if (result == 1) {
        setState(() {
          ttsState = TtsState.Stopped;
        });
      }
    }
  }

  void _sendMail() async {
    copyToClipboard();
    // Android and iOS
    String uri = 'mailto:?subject=Mail&body=${_inputText}';

    String parsedUri = Uri.parse(uri).toString();

    if (await canLaunch(parsedUri)) {
      await launch(parsedUri);
    } else {
      throw 'Could not launch $parsedUri';
    }
  }

  void _sendText() async {
    copyToClipboard();

    // Android
    const uri = 'sms:';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  Future<Null> _saveSentences() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs
          .setStringList("savedSentences", _savedSentences)
          .then((bool success) {});
    });
  }

  Future<Null> _deleteSentences() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.remove("savedSentences").then((bool success) {
        setState(() {
          keyBoardState = KeyBoardState.Letters;
        });
      }).catchError((e) {
        print("Could not delete: $e");
      });
      _savedSentences = [];
    });
  }

  Future<List<String>> _getSentences() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getStringList("savedSentences");
  }
}
