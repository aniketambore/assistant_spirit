import 'dart:io';
import 'dart:ui';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class SpiritMessage extends StatelessWidget {
  SpiritMessage(
      {this.text, this.type, this.avatarImage, this.image, this.imageWeb});

  final String text;
  final bool type;
  final String avatarImage;
  final File image;
  final String imageWeb;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? _myMessage(context) : _otherMessage(context),
      ),
    );
  }

  List<Widget> _otherMessage(context) {
    return <Widget>[
      Container(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/images/robot.png"),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Bubble(
                  radius: Radius.circular(15.0),
                  color: Color.fromRGBO(23, 157, 139, 1),
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                            child: Container(
                          constraints: BoxConstraints(maxWidth: 170),
                          child: SelectableText(
                            text,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Bubble(
                  radius: Radius.circular(15.0),
                  color: Colors.orangeAccent,
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 5.0,
                        ),
                        Flexible(
                            child: Container(
                                constraints: BoxConstraints(maxWidth: 170),
                                child: buildingMyMessage()
//                          image != null || imageWeb != null
//                               ? Image.file(image) ??
//                              imageWeb != null
//                                  ? Image(
//                                      image: imageWeb.image,
//                                    )
//                                  : SelectableText(
//                                      text,
//                                      style: TextStyle(
//                                          color: Colors.white,
//                                          fontWeight: FontWeight.bold),
//                                    ),
                                ))
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
      Container(
        height: 40,
        width: 40,
        child: CircleAvatar(
          child: Icon(Icons.supervised_user_circle_sharp),
        ),
      ),
    ];
  }

  buildingMyMessage() {
    if (image != null) {
      return Image.file(image);
    } else if (imageWeb != null) {
      return Image(
        image: NetworkImage("$imageWeb"),
      );
    } else {
      return SelectableText(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }
  }
}
