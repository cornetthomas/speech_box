import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_widget.dart';

class ValueButton extends StatelessWidget {
  String value;
  VoidStringCallBack pressed;

  ValueButton({@required this.value, @required this.pressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FlatButton(
        color: Colors.yellow,
        child: Text(value),
        onPressed: onButtonPressed,
      ),
    );
  }

  void onButtonPressed() {
    pressed(value);
  }
}
