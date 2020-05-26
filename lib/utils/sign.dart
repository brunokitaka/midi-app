import 'package:midiapp/pages/login.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:midiapp/pages/home.dart';
import 'package:midiapp/utils/info.dart' as info;

Future signIn(context, email, password, registrationToken) async {

  String url = info.mainUrl + '/authLogin';

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

    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(
            builder: (BuildContext context) => new HomePage()),
        (Route route) => route == null);
  } else {
    _showDialog(context, response);
  }
  // Navigator.of(context).pushAndRemoveUntil(
  //       new MaterialPageRoute(
  //           builder: (BuildContext context) => new HomePage()),
  //       (Route route) => route == null);
}

void signOut(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Fazer Logout?"),
        content: new Text("Deseja mesmo fazer logout?"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Cancelar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new RaisedButton(
            child: new Text(
              "Confirmar",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlueAccent,
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