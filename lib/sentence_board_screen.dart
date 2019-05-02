import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/icon_button_widget.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SentenceBoard extends StatefulWidget {
  SentenceBoardState createState() => new SentenceBoardState();
}

class SentenceBoardState extends State<SentenceBoard> {
  FlutterTts flutterTts;
  TtsState ttsState;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> _savedSentences = [];

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    ttsState = TtsState.Stopped;

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
      body: Center(
        child: SafeArea(
          child: Column(children: [
            Row(
              children: <Widget>[
                ActionButton(
                  displayValue: "Terug",
                  action: () {
                    Navigator.pop(context);
                  },
                ),
                ActionButton(
                  displayValue: "Verwijder zinnen",
                  action: () {
                    _deleteSentences();
                  },
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
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
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future speakText(String text) async {
    if (!(text == null) && !(ttsState == TtsState.Playing)) {
      ttsState = TtsState.Playing;
      var result = await flutterTts.speak(text);
      if (result == 1) {
        ttsState = TtsState.Stopped;
      }
    }
  }

  Future<Null> _deleteSentences() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.remove("savedSentences").then((bool success) {
        Navigator.pop(context);
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
