import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String displayValue;
  final VoidCallback action;
  final double width;
  final double height;

  ActionButton(
      {this.displayValue,
      @required this.action,
      this.height = 60.0,
      this.width = 200.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(4.0),
      child: RaisedButton(
        color: Colors.green,
        child: Text(
          displayValue,
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 22.0),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.black54, width: 2.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: onButtonPressed,
      ),
    );
  }

  void onButtonPressed() {
    action();
  }
}
