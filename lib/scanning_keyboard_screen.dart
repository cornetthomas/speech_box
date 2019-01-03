import 'package:flutter/material.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/icon_board_screen.dart';
import 'package:speech_box/suggestion_button_widget.dart';
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

  FlutterTts flutterTts;
  TtsState ttsState;
  List<String> keyboardValues;
  KeyBoardState keyBoardState;
  List<String> _savedSentences = [];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    ttsState = TtsState.Stopped;

    keyboardValues = letterValues;
    keyBoardState = KeyBoardState.Letters;

    setupTts();

    _getSentences().then((sentences) {
      setState(() {
        if (sentences != null) {
          _savedSentences = sentences;
        }
      });

      print(_savedSentences);
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
      appBar: AppBar(
        title: Text("SpraakBak"),
      ),
      body: Center(
        child: SafeArea(
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
                              color: Colors.white30,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)),
                              border: Border.all(
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height *
                                kTextFieldHeightFactor,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  _inputText.isNotEmpty
                                      ? Icon(
                                          Icons.surround_sound,
                                          size: 60.0,
                                          color: ttsState == TtsState.Playing
                                              ? Colors.green
                                              : Colors.black45,
                                        )
                                      : Container(),
                                  Text(
                                    _inputText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(fontSize: 36.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 100.0, child: buildSuggestions()),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        keyBoardState == KeyBoardState.Sentences
                            ? buildSentencesList()
                            : buildKeyboard(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueButton(
                                displayValue: "SPATIE",
                                value: " ",
                                pressed: updateInputWith,
                                width: 350.0,
                              ),
                              ActionButton(
                                displayValue:
                                    keyBoardState == KeyBoardState.Numbers
                                        ? "Letters"
                                        : "Cijfers",
                                color: Colors.red,
                                action: () {
                                  setState(() {
                                    keyboardValues =
                                        keyBoardState == KeyBoardState.Numbers
                                            ? letterValues
                                            : numberValues;
                                    keyBoardState =
                                        keyBoardState == KeyBoardState.Numbers
                                            ? KeyBoardState.Letters
                                            : KeyBoardState.Numbers;
                                  });
                                },
                              ),
                              ActionButton(
                                displayValue:
                                    keyBoardState == KeyBoardState.Sentences
                                        ? "Letters"
                                        : "Zinnen",
                                color: Colors.red,
                                action: () {
                                  setState(() {
                                    keyBoardState =
                                        keyBoardState == KeyBoardState.Sentences
                                            ? KeyBoardState.Letters
                                            : KeyBoardState.Sentences;
                                  });
                                },
                              ),
                              ActionButton(
                                displayValue: "Iconen",
                                action: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return IconBoard();
                                    }),
                                  );
                                },
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      ),
                      ActionButton(
                        displayValue: "SMS",
                        action: _sendText,
                        color: Colors.amber,
                      ),
                      ActionButton(
                        displayValue: "MAIL",
                        action: _sendMail,
                        color: Colors.amber,
                      ),
                      ActionButton(
                        displayValue: "Zin opslaan",
                        action: () {
                          setState(() {
                            _savedSentences.add(_inputText);
                            _saveSentences();
                          });

                          //_saveSentenceForKey("sentence", _inputText);
                        },
                      ),
                      ActionButton(
                        displayValue: "PRINT",
                        action: () {
                          print(_savedSentences);
                        },
                      ),
                      ActionButton(
                        displayValue: "DELETE",
                        action: () {
                          _deleteSentences();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> letterValues = [
    "e",
    "n",
    "t",
    "d",
    "g",
    "j",
    "a",
    "i",
    "r",
    "h",
    "v",
    "c",
    "o",
    "l",
    "k",
    "w",
    "f",
    ",",
    "s",
    "u",
    "z",
    "x",
    ".",
    "m",
    "b",
    "y",
    "?",
    "!",
    "p",
    "q",
  ];

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

  Widget buildKeyboard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(5.0),
          itemCount: keyboardValues.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0),
          itemBuilder: (BuildContext context, int index) {
            return ValueButton(
              displayValue: keyboardValues[index],
              value: keyboardValues[index],
              pressed: updateInputWith,
            );
          }),
    );
  }

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

    setState(() {
      _inputText = currentInput.substring(0, _lastSpaceIndex);
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
    print("Should speak");
    if (!(text == null) && !(ttsState == TtsState.Playing)) {
      print("Ok, to speak");
      ttsState = TtsState.Playing;
      var result = await flutterTts.speak(text);
      if (result == 1) {
        ttsState = TtsState.Stopped;
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
        print("Saved sentences deleted");
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
