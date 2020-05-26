import 'package:flutter/material.dart';
import 'package:midiapp/utils/info.dart';
import 'package:midiapp/utils/sign.dart';

class MyDrawer extends StatefulWidget { 
  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

/* NOT USED ANYMORE */
class _MyDrawerState extends State<MyDrawer> {
  // static final assetImage = new AssetImage('assets/fiboazul.png');
  // static final image = new Image(image: assetImage, height: 94.0, width: 145.0);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            // accountName: Text('Farmácia', style: TextStyle(color: Color(0xFF3d3d3d))),
            accountEmail: Text(email, style: TextStyle(color: Color(0xFF3d3d3d))),
            currentAccountPicture: new Container(
              child: Image(image: AssetImage('assets/midi.png')),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50
            ),
          ),
          new ListTile(
            title: new Text("Configuração", style: TextStyle(fontSize: 15.0, color: Color(0xFF3d3d3d)),),
            leading: new Icon(Icons.settings, color: Color(0xFF666666)),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => WarningsPage()),
              // );
            },
          ),
          new ListTile(
            title: new Text("Sign Out", style: TextStyle(fontSize: 15.0, color: Color(0xFF3d3d3d)),),
            leading: new Icon(Icons.exit_to_app, color: Color(0xFF666666)),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}