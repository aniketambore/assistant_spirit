import 'package:assistant_spirit/models/user_model.dart';
import 'package:assistant_spirit/screens/chatscreens/chat_screen.dart';
import 'package:assistant_spirit/screens/chatscreens/model/contact.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/screens/page_views/widgets/custom_tile.dart';
import 'package:assistant_spirit/screens/page_views/widgets/last_message_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  ContactView(this.contact);

  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await userRef.document(id).get();
      return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      // print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;
          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  ViewLayout({@required this.contact});

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {@required String senderId, @required String receiverId}) =>
      Firestore.instance
          .collection("messages")
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return CustomTile(
        mini: false,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      receiver: contact,
                    ))),
        title: Text(
          //"Aniket Ambore",
          contact?.username ?? "...",
          style:
              TextStyle(color: Colors.white, fontSize: 19, fontFamily: "Arial"),
        ),
        subtitle: LastMessageContainer(
          stream: fetchLastMessageBetween(
              senderId: currentUser.id, receiverId: contact.id),
        ),
        leading: Container(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundImage: NetworkImage("${contact.photoUrl}"),
          ),
        ));
  }
}
