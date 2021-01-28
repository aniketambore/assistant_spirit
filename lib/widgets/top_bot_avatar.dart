import 'package:flutter/material.dart';

class TopBotAvatar extends StatelessWidget {
  final String tag;
  TopBotAvatar({this.tag});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Hero(
          tag: "$tag",
          child: Image(
            image: AssetImage("assets/images/robot.png"),
          ),
        ),
      ),
    );
  }
}
