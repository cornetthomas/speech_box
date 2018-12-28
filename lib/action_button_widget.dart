import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String displayValue;
  final VoidCallback action;

  ActionButton({this.displayValue, @required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FlatButton(
        color: Colors.green,
        child: Text(
          displayValue,
          style: Theme.of(context).textTheme.title.copyWith(fontSize: 30.0),
        ),
        onPressed: onButtonPressed,
      ),
    );
  }

  void onButtonPressed() {
    action();
  }
}
