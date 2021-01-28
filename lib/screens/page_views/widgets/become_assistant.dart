import 'dart:async';

import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/widgets/top_bot_avatar.dart';
import 'package:flutter/material.dart';

class BecomeAssistant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(50)),
      child: IconButton(
        tooltip: "Become Assistant",
        icon: Icon(
          Icons.assignment_ind_outlined,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => AssistantBecomingOption())),
      ),
      padding: EdgeInsets.all(15),
    );
  }
}

class AssistantBecomingOption extends StatefulWidget {
  @override
  _AssistantBecomingOptionState createState() =>
      _AssistantBecomingOptionState();
}

class _AssistantBecomingOptionState extends State<AssistantBecomingOption> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Become Assistant"),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black54, Colors.blueGrey],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBotAvatar(tag: "assistant-spirit-1"),
              SizedBox(height: 20),
              SizedBox(
                  //height: MediaQuery.of(context).size.height,
                  //width: MediaQuery.of(context).size.width,
                  child: currentUser.isAssistant
                      ? isAssistant()
                      : isNotAssistant()),
            ],
          ),
        ));
  }

  Widget isNotAssistant() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: Colors.blueGrey,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SelectableText(
                "Do you want to become human assistant ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              SelectableText(
                "You need to assist the user as their personal human assistant.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "BECOME ASSISTANT",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: becomeAssistant,
              ),
            ],
          ),
          //      ),
        ),
      ),
    );
  }

  becomeAssistant() async {
    final doc = await userRef.document(currentUser.id).get();

    if (doc.exists) {
      doc.reference.updateData({"isAssistant": true});
      SnackBar snackBar = SnackBar(
        content: Text(
          "Welcome Human Assistant !",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      setState(() {
        currentUser.isAssistant = true;
      });

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Widget isAssistant() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: Colors.blueGrey,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SelectableText(
                "Do you want to drop your assistant role?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              SelectableText(
                "You will no longer be able to assist any user.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: Colors.redAccent,
                child: Text(
                  "DROP ASSISTANT ROLE",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: dropAssistant,
              ),
            ],
          ),
          //      ),
        ),
      ),
    );
  }

  dropAssistant() async {
    final doc = await userRef.document(currentUser.id).get();

    if (doc.exists) {
      doc.reference.updateData({"isAssistant": false});
      SnackBar snackBar = SnackBar(
        content: Text(
          "Human Assistant Role Dropped !",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      setState(() {
        currentUser.isAssistant = false;
      });

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}
