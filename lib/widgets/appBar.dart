import 'package:flutter/material.dart';

Widget myAppBar() {
  final assetImage = new AssetImage('assets/midi.png');
  final image = new Image(image: assetImage, height: 100.0, width: 100.0);

    return AppBar(
      title: new Container(
        child: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image,
            ],
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 10,
      iconTheme: new IconThemeData(
        color: Colors.grey.shade500
      ),
    );
}