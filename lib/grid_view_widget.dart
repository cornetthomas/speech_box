import 'package:flutter/material.dart';

class MainGridView extends StatelessWidget {
  final List<Widget> elements;
  final Widget topChild;
  final Widget subChild;

  MainGridView(this.elements, this.topChild, this.subChild);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.15, child: topChild),
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          child: subChild,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: GridView.count(
            crossAxisCount: 6,
            children: List.generate(elements.length, (index) {
              return elements[index];
            }),
          ),
        ),
      ],
    );
  }
}
