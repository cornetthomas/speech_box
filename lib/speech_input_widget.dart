import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';

class SpeechInput extends StatefulWidget {
  final VoidStringCallBack onSpeak;

  final inputValue;

  SpeechInput(this.inputValue, this.onSpeak);

  @override
  _SpeechInputState createState() => _SpeechInputState();
}

class _SpeechInputState extends State<SpeechInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onTap: () {
                widget.onSpeak(widget.inputValue);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white30,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  border: Border.all(
                    width: 2.0,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.10,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      widget.inputValue.isNotEmpty
                          ? Icon(
                              Icons.surround_sound,
                              size: 60.0,
                              color: Colors.black45,
                            )
                          : Container(),
                      Text(
                        widget.inputValue,
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
    );
  }
}
