import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';

class ValueButton extends StatelessWidget {
  final String value;
  final String displayValue;
  final VoidStringCallBack pressed;
  final double width;
  final double height;

  ValueButton({
    @required this.value,
    this.displayValue,
    @required this.pressed,
    this.height = 60.0,
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(4.0),
      child: RaisedButton(
        color: Colors.greenAccent,
        child: Text(
          displayValue,
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(fontSize: 50.0, fontWeight: FontWeight.bold),
        ),
        onPressed: onButtonPressed,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.black54, width: 2.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  void onButtonPressed() {
    pressed(value);
  }
}
