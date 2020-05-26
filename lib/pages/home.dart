import 'package:flutter/material.dart';

import 'package:midiapp/widgets/appBar.dart';
import 'package:midiapp/widgets/drawerMenu.dart';
import 'package:midiapp/widgets/ideaCard.dart';
import 'package:midiapp/pages/recording.dart';

import 'package:midiapp/utils/apis.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List ideasList = new List();

  @override
  void initState() {
    super.initState();
    callMidiApi();
  }

  Future callMidiApi() async {
    setState(() {
      ideasList = [];
      //print(ideasList);
    });
    List response = await getUserIdeas();
    setState(() {
      ideasList = response;
      print(ideasList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: new MyDrawer(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          // callMidiApi();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordingPage()),
          );
        },
      ),
      body: new Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(
          backgroundColor: Colors.grey.shade500,
        ),
      )
    );
  }
}
