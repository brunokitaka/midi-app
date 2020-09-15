import 'package:flutter/material.dart';

import 'package:midiapp/utils/sign.dart';
import 'package:midiapp/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _registrationToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MidiLogo(),
            // new Text("MIDI MATE", style: TextStyle(fontSize: 20.0, color: Colors.black)),
            new SizedBox(height: 70.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new Card(
                elevation: 8.0,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 30.0, right: 30.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff6f42c1)),
                        child: new TextField(
                          controller: _emailController,
                          decoration: new InputDecoration(
                            suffixIcon: new Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email",
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff6f42c1))),
                          ),
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 12.0,
                    ),
                    new Container(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff6f42c1)),
                        child: new TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: new InputDecoration(
                            suffixIcon: new Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Password",
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff6f42c1))),
                          ),
                        ),
                      ),
                    ),
                    new SizedBox(height: 30.0),
                    new RaisedButton(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.white,
                      child: new Text(
                        "Sign In",
                        style: new TextStyle(
                            color: Color(0xff6f42c1), fontSize: 20.0),
                      ),
                      onPressed: () => signIn(context, _emailController.text,
                          _passwordController.text, _registrationToken),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ],
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(20.0),
            ),
          ],
        ),
      ),
    );
  }
}
