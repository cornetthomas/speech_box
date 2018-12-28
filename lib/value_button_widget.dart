import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_widget.dart';

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
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        border: Border.all(
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FlatButton(
          child: Text(
            displayValue,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 36.0),
          ),
          onPressed: onButtonPressed,
        ),
      ),
    );
  }

  void onButtonPressed() {
    pressed(value);
  }
}
