import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUsernameScreen extends StatefulWidget {
  @override
  _CreateUsernameScreenState createState() => _CreateUsernameScreenState();
}

class _CreateUsernameScreenState extends State<CreateUsernameScreen>
    with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String username;
  bool botVisible = false;
  bool animationTop = false;
  bool animationMiddle = false;
  bool formInput = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget inputWidget;

  void animationGo(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      botVisible = true;
    });
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        animationTop = true;
      });
    });

    Timer(Duration(milliseconds: 2300), () {
      setState(() {
        animationMiddle = true;
      });
    });

    Timer(Duration(milliseconds: 3500), () {
      setState(() {
        formInput = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => animationGo(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            botTopContainer(),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              height: animationMiddle ? 20 : 80,
            ),
            botMiddleGreetings(),
            SizedBox(height: 20),
            formSubmit(),
          ],
        ),
      ),
    );
  }

  Widget botTopContainer() {
    return AnimatedOpacity(
      opacity: (animationTop) ? 1 : 0,
      duration: Duration(seconds: 1),
      child: Column(
        children: <Widget>[
          AnimatedOpacity(
            opacity: (botVisible) ? 1 : 0,
            duration: Duration(seconds: 1),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage("assets/images/robot.png"),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SelectableText(
            "Hello!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
                textBaseline: TextBaseline.ideographic),
          ),
          SelectableText(
            "My name is Spirit.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                textBaseline: TextBaseline.ideographic),
          ),
        ],
      ),
    );
  }

  Widget botMiddleGreetings() {
    return AnimatedOpacity(
      opacity: animationMiddle ? 1 : 0,
      duration: Duration(seconds: 1),
      child: SelectableText(
        "Nice to meet you! \nWhat is your name?",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            textBaseline: TextBaseline.ideographic),
      ),
    );
  }

  Widget formSubmit() {
    return AnimatedOpacity(
      opacity: formInput ? 1 : 0,
      duration: Duration(seconds: 1),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            autovalidate: true,
            child: TextFormField(
              validator: (val) {
                if (val.trim().length < 3 || val.isEmpty) {
                  return "Username Too Short";
                } else if (val.trim().length > 12) {
                  return "Username Too Long";
                } else {
                  return null;
                }
              },
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
                hintText: "My name is...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              autofocus: false,
              onSaved: (val) => username = val,
            ),
          ),
          SizedBox(height: 35),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              width: 180,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.done,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Material(
                    color: Colors.white.withOpacity(0.0),
                    child: InkWell(
                        splashColor: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(30),
                        onTap: submit),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.black54,
        content: Text(
          "Welcome $username !",
          style: TextStyle(color: Colors.tealAccent),
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }
}
