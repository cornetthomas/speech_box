import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_box/action_button_widget.dart';
import 'package:speech_box/icon_button_widget.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';

class IconBoard extends StatefulWidget {
  IconBoardState createState() => new IconBoardState();
}

class IconBoardState extends State<IconBoard> {
  List<IconBoardButton> _iconBoardButtons;

  FlutterTts flutterTts;
  TtsState ttsState;

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    ttsState = TtsState.Stopped;

    _iconBoardButtons = [
      IconBoardButton(
        value: "Hoe gaat het me jou?",
        icon: Icon(Icons.chat_bubble),
        pressed: speakText,
      ),
      IconBoardButton(
        value: "Met mij is het goed.",
        icon: Icon(Icons.check_circle),
        pressed: speakText,
      ),
      IconBoardButton(
        value: "Dankjewel!",
        icon: Icon(Icons.sentiment_very_satisfied),
        pressed: speakText,
      )
    ];

    setupTts();
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
      appBar: AppBar(
        title: Text("SpraakBak"),
      ),
      body: Center(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(5.0),
              itemCount: _iconBoardButtons.length + 1,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (BuildContext context, int index) {
                if (index == _iconBoardButtons.length) {
                  return ActionButton(
                    displayValue: "Terug",
                    action: () {
                      Navigator.pop(context);
                    },
                  );
                }
                return _iconBoardButtons[index];
              },
            ),
          ),
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
}
