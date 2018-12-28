import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_widget.dart';

class SuggestionButton extends StatelessWidget {
  final String value;
  final String displayValue;
  final VoidStringCallBack pressed;
  final double width;
  final double height;

  SuggestionButton({
    @required this.value,
    this.displayValue,
    @required this.pressed,
    this.height = 90.0,
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        child: Text(
          displayValue,
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 36.0),
        ),
        onPressed: onButtonPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.blueGrey, width: 2.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  void onButtonPressed() {
    pressed(value);
  }
}
