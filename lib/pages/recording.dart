import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => new _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Recording Idea', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(
            color: Colors.grey.shade500
          ),
        ),
        body: new AppBody(),
      );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                onPressed: _isRecording ? null : _start,
                child: new Text("Start"),
                color: Colors.grey,
              ),
              new FlatButton(
                onPressed: _isRecording ? _stop : null,
                child: new Text("Stop"),
                color: Colors.red,
              ),
              new TextField(
                controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Enter recording name',
                ),
              ),
              new Text("File path of the record: ${_recording.path}"),
              new Text("Format: ${_recording.audioOutputFormat}"),
              new Text("Extension : ${_recording.extension}"),
              new Text(
                  "Audio recording duration : ${_recording.duration.toString()}")
            ]),
      ),
    );
  }

  _start() async {
    try {
      PermissionStatus micstatus = await Permission.microphone.request();
      PermissionStatus storagestatus = await Permission.storage.request();
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.WAV);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
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
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
  }
}