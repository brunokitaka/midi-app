import 'package:flutter/material.dart';
import 'package:midiapp/utils/info.dart';
import 'package:midiapp/utils/storage.dart';

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
    refreshIdeas();
  }

  Future refreshIdeas() async {
    setState(() {
      ideasList = [];
    });

    List response = await getUserIdeas();

    setState(() {
      ideasList = response;
      print(ideasList);
    });
  }

  Future<List> getUserIdeas() async {
    DbConnection database = new DbConnection();

    paths = [];
        
    List ideas = await database.selectUserIdeas(userId);
    print("IDEAS = " + ideas.toString());

    for(var i = 0; i < ideas.length; i++){
      List<Map> response = await database.selectIdeasPaths(ideas[i]["idIdea"]);
      Map item = {
        "path": response[0]["path"].toString(),
        "name": response[0]["name"].toString()
      };
      paths.add(item);
    }

    print("PATHS = " + paths.toString());

    return paths;
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
      body: RefreshIndicator(
        child: new ListView.builder(
          // padding: const EdgeInsets.all(15.0),
          itemCount: paths.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12
                    )
                  )
                ),
                padding: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
                child: Column(
                  children: [
                    Text(paths[index]["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 7.0),
                    Text("Path: " + paths[index]["path"], style: TextStyle(fontSize: 10.0))
                  ]
                )
              ),
              onTap: () {

              }
            );
          }
        ),
        onRefresh: refreshIdeas
      )
    );
  }
}
