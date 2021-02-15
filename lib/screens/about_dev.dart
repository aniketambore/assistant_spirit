import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDev extends StatefulWidget {
  @override
  _AboutDevState createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About Developer"),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black54, Colors.blueGrey],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
            child: bodyUI()));
  }

  Widget bodyUI() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
              top: 100,
            ),
            child: Image.asset(
              "assets/images/robot.png",
            ),
            height: 300,
            width: 600,
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(left: 0, top: 100),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical, child: aboutDevContainer()),
          ),
        )
        //
      ],
    );
  }

  Widget aboutDevContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SelectableText(
              "HELLO, I'M",
              style: TextStyle(
                color: Colors.tealAccent,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SelectableText(
            "ANIKET AMBORE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SelectableText(
            "Software Developer",
            style: TextStyle(
              color: Colors.white.withOpacity(.50),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  launch("https://github.com/aniketambore");
                },
                child: Image.network(
                  "https://github.githubassets.com/images/modules/logos_page/Octocat.png",
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  launch("https://aniketambore.itch.io/");
                },
                child: Image.network(
                  "https://www.pinclipart.com/picdir/big/398-3984001_itch-io-logo-clipart.png",
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  var email = "mailto:aniketambore0@gmail.com" +
                      "?subject=Assistant Spirit" +
                      "&body=Nice App Aniket.";
                  launch("$email");
                },
                child: Image.network(
                  "https://cdn4.iconfinder.com/data/icons/social-media-logos-6/512/112-gmail_email_mail-512.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
