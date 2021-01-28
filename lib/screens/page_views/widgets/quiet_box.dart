import 'package:assistant_spirit/screens/search_screen.dart';
import 'package:flutter/material.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blueGrey,
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SelectableText(
              heading,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                textBaseline: TextBaseline.ideographic,
              ),
            ),
            SizedBox(height: 25),
            SelectableText(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                textBaseline: TextBaseline.ideographic,
              ),
            ),
            SizedBox(height: 25),
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                "START SEARCHING",
                style: TextStyle(
                  color: Colors.black,
                  textBaseline: TextBaseline.ideographic,
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              ),
            ),
          ],
        ),
        //      ),
      ),
    );
  }
}
