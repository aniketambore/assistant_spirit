import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/widgets/bar_avatar.dart';
import 'package:flutter/material.dart';

class UserCircle extends StatelessWidget {
  final String userId;
  UserCircle({this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRef.document(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BarAvatar(
            isBot: false,
            isHuman: true,
            url: "$photoUrl",
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
