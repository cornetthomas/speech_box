import 'package:flutter/material.dart';
import 'package:speech_box/scanning_keyboard_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpraakBak',
      showSemanticsDebugger: false,
      theme: ThemeData(primaryColor: Colors.red),
      home: new MyHomePage(title: 'SpraakBak'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ScanningKeyboard();
  }
}
