import 'package:midiapp/pages/login.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:midiapp/pages/home.dart';
import 'package:midiapp/utils/info.dart' as info;
import 'package:midiapp/utils/storage.dart';

Future signIn(context, email, password, registrationToken) async {
  DbConnection database = new DbConnection();

  String url = info.mainUrl + '/mobileLogin';

  Map account = {
    'email': email,
    'password': password,
  };

  Map response;

  json.encode(account);

  response = await info.Session().post(url, account);

  if (response["status"] == "success") {
    info.token = response["data"]["token"];
    info.email = email;
    info.userId = response["data"]["idUser"];

    print(info.token);
    print(info.userId);

    List user = await database.selectUser(info.userId);

    print("USERS = " + user.toString());

    if(user.isEmpty || user == null){
      await database.insertUser(info.userId);
      print("NEW USER INSERTED");
    }
    else{
      print("USER FOUND, SEARCHING PATHS");

      List ideas = await database.selectUserIdeas(info.userId);
      print("IDEAS = " + ideas.toString());

      for(var i = 0; i < ideas.length; i++){
        List<Map> response = await database.selectIdeasPaths(ideas[i]["idIdea"]);
        Map item = {
          "idIdea": response[0]["idIdea"].toString(),
          "path": response[0]["path"].toString(),
          "name": response[0]["name"].toString()
        };
        info.paths.add(item);
      }

      print("PATHS = " + info.paths.toString());
    }

    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage()),
        (Route route) => route == null);
  } else {
    _showDialog(context, response);
  }
}

void signOut(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Logout?"),
        content: new Text("Do you really want to logout?"),
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
              "Confirm",
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xff6f42c1),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new LoginPage()),
                  (Route route) => route == null);
            },
          ),
        ],
      );
    },
  );
}

void _showDialog(context, response) {
  print(response);
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Login",
          style: new TextStyle(
            color: Colors.grey.shade800
          ),
        ),
        content: Text(response['msg'] is List ? response['msg'][0]['msg'] : response['msg'],
          style: new TextStyle(
            color: Colors.grey.shade800
          ),
        ), //Text("Usuário ou senha incorretos"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new RaisedButton(
            color: Colors.white,
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}