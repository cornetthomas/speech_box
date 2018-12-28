import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_widget.dart';

class ValueButton extends StatelessWidget {
  final String value;
  final String displayValue;
  final VoidStringCallBack pressed;

  ValueButton(
      {@required this.value, this.displayValue, @required this.pressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FlatButton(
        color: Colors.yellow,
        child: Text(
          displayValue,
          style: Theme.of(context).textTheme.title,
        ),
        onPressed: onButtonPressed,
      ),
    );
  }

  void onButtonPressed() {
    pressed(value);
  }
}
