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
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        border: Border.all(
          width: 2.0,
        ),
      ),
      child: FlatButton(
        child: Text(
          displayValue,
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 22.0),
        ),
        onPressed: onButtonPressed,
      ),
    );
  }

  void onButtonPressed() {
    action();
  }
}
