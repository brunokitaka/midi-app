import 'package:flutter/material.dart';

class MidiLogo extends StatelessWidget {

  var image = new Image.asset('assets/midi.png', height: 94.0, width: 145.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image
    );
  }
}