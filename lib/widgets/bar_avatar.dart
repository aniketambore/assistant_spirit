import 'package:flutter/material.dart';

class BarAvatar extends StatelessWidget {
  final bool isBot;
  final bool isHuman;
  final String url;
  BarAvatar({this.isBot, this.isHuman, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.greenAccent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: Offset(0, 2),
                blurRadius: 5)
          ],
        ),
        child: isHuman == true
            ? CircleAvatar(backgroundImage: NetworkImage("$url"))
            : CircleAvatar(
                backgroundImage: AssetImage("$url"),
              ));
  }
}
