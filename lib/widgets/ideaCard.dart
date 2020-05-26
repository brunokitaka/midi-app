import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
            title: Text("${idea["ideaName"]}",
                style: new TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                )
            ),
        ),
      ),
    ));
  }
}