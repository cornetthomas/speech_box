import 'package:flutter/material.dart';

class SettingsDrawer extends StatefulWidget {
  SettingsDrawerState createState() => SettingsDrawerState();
}

class SettingsDrawerState extends State<SettingsDrawer> {
  double _ttsSpeed = 0.5;
  double _ttsPitch = 1.0;
  double _ttsVolume = 1.0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Settings",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red, fontSize: 22.0),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Text to Speech",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red, fontSize: 16.0),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Speed"),
                  Text(_ttsSpeed.toStringAsPrecision(1)),
                  Slider(
                    label: "Speed: ",
                    value: _ttsSpeed,
                    max: 1.0,
                    min: 0.0,
                    onChanged: (double newValue) {
                      setState(() {
                        _ttsSpeed = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Volume"),
                  Text(_ttsVolume.toStringAsPrecision(1)),
                  Slider(
                    label: "Volume: ",
                    value: _ttsVolume,
                    max: 1.0,
                    min: 0.0,
                    onChanged: (double newValue) {
                      setState(() {
                        _ttsVolume = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("Speed"),
                  Text(_ttsPitch.toStringAsPrecision(1)),
                  Slider(
                    label: "Pitch: ",
                    value: _ttsPitch,
                    max: 1.0,
                    min: 0.0,
                    onChanged: (double newValue) {
                      setState(() {
                        _ttsPitch = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
