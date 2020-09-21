// import 'package:audio_manager/audio_manager.dart';
// import 'package:flutter/material.dart';

// class Player extends StatefulWidget {
//   final String title;
//   final String path;

//   Player(this.title, this.path);

//   @override
//   _PlayerState createState() => _PlayerState(title, path);
// }

// class _PlayerState extends State<Player> {
//   String title;
//   String path;

//   _PlayerState(this.title, this.path);

//   @override
//   void initState() {
//     super.initState();
//   }

  
// }
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:midiapp/utils/info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/constants.dart';

import 'package:midiapp/utils/storage.dart';
import 'package:midiapp/widgets/player_widget.dart';

typedef void OnError(Exception exception);

class Player extends StatefulWidget {
  final String filename;
  final int webId;
  Player(this.filename, this.webId);
  @override
  _PlayerState createState() => _PlayerState(this.filename, this.webId);
}

class _PlayerState extends State<Player> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String localFilePath;
  String filename;
  int webId;

  _PlayerState(this.filename, this.webId);

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Calls to Platform.isIOS fails on web
      return;
    }
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
      advancedPlayer.startHeadlessService();
    }
  }

  Widget remoteUrl1() {

    String url1 = mainUrl + "/playable/$webId/1.wav";

    return PlayerWidget(url: url1);
  }

  Widget remoteUrl2() {

    String url2 = mainUrl + "/playable/$webId/2.wav";

    return PlayerWidget(url: url2);
  }

  Widget remoteUrl3() {

    String url3 = mainUrl + "/playable/$webId/3.wav";

    return PlayerWidget(url: url3);
  }

  Future _loadFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${filename}.m4a');

    if (await file.exists()) {
      setState(() {
        localFilePath = file.path;
      });
    }
  }

  Widget localFile() {
    _loadFile();
    return _Tab(children: [
      // Text('Current local file path: $localFilePath'),
      localFilePath == null
          ? Container()
          : PlayerWidget(
              url: localFilePath,
            ),
    ]);
  }

  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(
      audiofile.path,
    );
    int duration = await Future.delayed(
        Duration(seconds: 2), () => advancedPlayer.getDuration());
    return duration;
  }

  getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(
                'audio2.mp3 duration is: ${Duration(milliseconds: snapshot.data)}');
        }
        return null; // unreachable
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
            initialData: Duration(),
            value: advancedPlayer.onAudioPositionChanged),
      ],
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Playing ${filename}", style: TextStyle(color: Colors.black),),
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: new IconThemeData(
              color: Colors.grey.shade500
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Recording", style: TextStyle(color: Colors.black, fontSize: 12.0),),
                ),
                Tab(
                  child: Text("Suggestion 1", style: TextStyle(color: Colors.black, fontSize: 10.0),),
                ),
                Tab(
                  child: Text("Suggestion 2", style: TextStyle(color: Colors.black, fontSize: 10.0),),
                ),
                Tab(
                  child: Text("Suggestion 3", style: TextStyle(color: Colors.black, fontSize: 10.0),),
                ),
              ]
            ),
          ),
          body: TabBarView(
            children:[
              Container(
                child: localFile(),
              ),
              Container(
                child: remoteUrl1(),
              ),
              Container(
                child: remoteUrl2(),
              ),
              Container(
                child: remoteUrl3(),
              ),
            ]
          )
        ),
      )
    );
  }
}

class _Tab extends StatelessWidget {
  final List<Widget> children;

  const _Tab({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children
                .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}