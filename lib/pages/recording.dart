// import 'dart:io' as io;
// import 'dart:math';

// import 'package:audio_recorder/audio_recorder.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file/file.dart';
// import 'package:file/local.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class RecordingPage extends StatefulWidget {
//   @override
//   _RecordingPageState createState() => new _RecordingPageState();
// }

// class _RecordingPageState extends State<RecordingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Recording Idea', style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           iconTheme: new IconThemeData(
//             color: Colors.grey.shade500
//           ),
//         ),
//         body: new AppBody(),
//       );
//   }
// }

// class AppBody extends StatefulWidget {
//   final LocalFileSystem localFileSystem;

//   AppBody({localFileSystem})
//       : this.localFileSystem = localFileSystem ?? LocalFileSystem();

//   @override
//   State<StatefulWidget> createState() => new AppBodyState();
// }

// class AppBodyState extends State<AppBody> {
//   Recording _recording = new Recording();
//   bool _isRecording = false;
//   Random random = new Random();
//   TextEditingController _controller = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return new Center(
//       child: new Padding(
//         padding: new EdgeInsets.all(8.0),
//         child: new Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               new FlatButton(
//                 onPressed: _isRecording ? null : _start,
//                 child: new Text("Start"),
//                 color: Colors.grey,
//               ),
//               new FlatButton(
//                 onPressed: _isRecording ? _stop : null,
//                 child: new Text("Stop"),
//                 color: Colors.red,
//               ),
//               new TextField(
//                 controller: _controller,
//                 decoration: new InputDecoration(
//                   hintText: 'Enter recording name',
//                 ),
//               ),
//               new Text("File path of the record: ${_recording.path}"),
//               new Text("Format: ${_recording.audioOutputFormat}"),
//               new Text("Extension : ${_recording.extension}"),
//               new Text(
//                   "Audio recording duration : ${_recording.duration.toString()}")
//             ]),
//       ),
//     );
//   }

//   _start() async {
//     try {
//       PermissionStatus micstatus = await Permission.microphone.request();
//       PermissionStatus storagestatus = await Permission.storage.request();
//       if (await AudioRecorder.hasPermissions) {
//         if (_controller.text != null && _controller.text != "") {
//           String path = _controller.text;
//           if (!_controller.text.contains('/')) {
//             io.Directory appDocDirectory =
//                 await getApplicationDocumentsDirectory();
//             path = appDocDirectory.path + '/' + _controller.text;
//           }
//           print("Start recording: $path");
//           await AudioRecorder.start(
//               path: path, audioOutputFormat: AudioOutputFormat.WAV);
//         } else {
//           await AudioRecorder.start();
//         }
//         bool isRecording = await AudioRecorder.isRecording;
//         setState(() {
//           _recording = new Recording(duration: new Duration(), path: "");
//           _isRecording = isRecording;
//         });
//       } else {
//         Scaffold.of(context).showSnackBar(
//             new SnackBar(content: new Text("You must accept permissions")));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   _stop() async {
//     var recording = await AudioRecorder.stop();
//     print("Stop recording: ${recording.path}");
//     bool isRecording = await AudioRecorder.isRecording;
//     File file = widget.localFileSystem.file(recording.path);
//     print("  File length: ${await file.length()}");
//     setState(() {
//       _recording = recording;
//       _isRecording = isRecording;
//     });
//     _controller.text = recording.path;
//   }
// }

import 'dart:io' as io;
import 'dart:math';

import 'package:midiapp/utils/apis.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midiapp/utils/info.dart';
import 'package:midiapp/utils/storage.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final LocalFileSystem localFileSystem = LocalFileSystem();

  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
  var id;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recording",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.grey.shade500),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 70.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff6f42c1)),
              child: TextField(
                controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Enter idea name',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 300.0,
          ),
          ButtonTheme(
            minWidth: 200.0,
            height: 100.0,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: _isRecording ? _stop : _start,
                color: Colors.white,
                child: Icon(
                  _isRecording ? FontAwesome.stop : FontAwesome.microphone,
                  color: Color(0xff6f42c1),
                  size: 45.0,
                )),
          ),
          SizedBox(
            height: 50.0,
          ),
          // new Text("File path of the record: ${_recording.path}"),
          //   new Text("Format: ${_recording.audioOutputFormat}"),
          //   new Text("Extension : ${_recording.extension}"),
          //   new Text(
          //       "Audio recording duration : ${_recording.duration.toString()}")
        ],
      )),
    );
  }

  _start() async {
    try {
      PermissionStatus micstatus = await Permission.microphone.request();
      PermissionStatus storagestatus = await Permission.storage.request();
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text + ".aac";
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);

          bool isRecording = await AudioRecorder.isRecording;
          setState(() {
            _recording = new Recording(duration: new Duration(), path: "");
            _isRecording = isRecording;
          });

          _insertNewRecording(path, _controller.text);
        }
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    // _controller.text = recording.path;
    _controller.text = "";

    sendRecord(recording.path, id);
  }

  _insertNewRecording(path, name) async {
    DbConnection database = new DbConnection();

    var idIdea = await database.insertIdea({"path": path, "name": name});

    await database.insertUserIdea({"idIdea": idIdea, "userId": userId});

    id = idIdea;
    //TO DO: SEND AUDIO FILE TO BACKEND
  }
}
