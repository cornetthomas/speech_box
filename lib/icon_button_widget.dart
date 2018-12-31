import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';

class IconBoardButton extends StatelessWidget {
  final String value;
  final Icon icon;
  final VoidStringCallBack pressed;
  final double width;
  final double height;

  IconBoardButton({
    @required this.value,
    this.icon,
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
        color: Colors.red,
        child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: Theme.of(context).iconTheme.copyWith(size: 90.0),
            ),
            child: icon),
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
