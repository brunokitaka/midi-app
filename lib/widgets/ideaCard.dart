import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:midiapp/pages/home.dart';

import 'package:midiapp/utils/apis.dart';
import 'package:midiapp/utils/storage.dart';

class IdeaCard extends StatefulWidget {
  final Map idea;

  IdeaCard(this.idea);

  @override
  _IdeaCardState createState() => _IdeaCardState(idea);
}

class _IdeaCardState extends State<IdeaCard> {
  final Map idea;

  _IdeaCardState(this.idea);

  @override
  Widget build(BuildContext context) {
    print(idea);
    
    return new GestureDetector(
      // onTap: () {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => MeasuresPage(fridge["idfridge"], fridge["sensor"])));
      // },
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: new Container(
          child: new ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: new Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.grey))),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Icon(
                      FontAwesome.music,
                      color: Colors.grey.shade600,
                      size: 28.0,
                    ),
                  ],
                )
            ),
            title: Text("${idea["name"]}",
                style: new TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )
            ),
            trailing: ButtonTheme(
              minWidth: 10.0,
              child: FlatButton(
                child: Icon(
                  FontAwesome.trash,
                  color: Colors.red,
                ),
                onPressed: () => eraseIdeaDialog(context),
              ),
            ),
        ),
      ),
    ));
  }

  // eraseIdea(){

  // }

  void eraseIdeaDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erase idea?"),
          content: new Text("Recording and suggestions will be erased from your account!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new RaisedButton(
              child: new Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () => eraseIdea(context),
            ),
          ],
        );
      },
    );
  }

  eraseIdea(context) async {
    DbConnection database = new DbConnection();

    print("ID = " + idea["idIdea"].toString());
    bool response = await requestEraseIdea(idea["idIdea"]);

    if(!response){
      Navigator.of(context).pop();
      errorMessage(context);
    }
    else{
      final file = File(idea["path"]);
      file.deleteSync();
    
      await database.deleteUserIdea(idea["idIdea"]);
      await database.deleteIdea(idea["idIdea"]);

      Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage()),
        (Route route) => route == null);
    }    
  }

  errorMessage(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
            "Unespected error, try again later!"
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new HomePage()),
                  (Route route) => route == null);
              },
            ),
          ],
        );
      },
    );
  }
}