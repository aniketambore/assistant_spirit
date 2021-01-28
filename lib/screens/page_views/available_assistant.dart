import 'package:assistant_spirit/models/user_model.dart';
import 'package:assistant_spirit/screens/chatscreens/chat_screen.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/screens/page_views/widgets/custom_tile.dart';
import 'package:assistant_spirit/widgets/appbar.dart';
import 'package:assistant_spirit/widgets/top_bot_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvailableAssistant extends StatefulWidget {
  @override
  _AvailableAssistantState createState() => _AvailableAssistantState();
}

class _AvailableAssistantState extends State<AvailableAssistant> {
  List<UserModel> userList;

  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot =
        await userRef.where("isAssistant", isEqualTo: true).getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.id) {
        userList.add(UserModel.fromMap(querySnapshot.documents[i].data()));
      }
    }
    return userList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllUsers().then((List<UserModel> list) {
      setState(() {
        userList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        title: SelectableText(
          "Human Assistants",
          style: TextStyle(
              color: Colors.white, textBaseline: TextBaseline.ideographic),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Column(
          children: [
            //Top Bot Fade Image
            TopBotAvatar(tag: "assistant-spirit-3"),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SelectableText(
                            "Available Human Assistant",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                textBaseline: TextBaseline.ideographic),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: buildSuggestion(" "),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSuggestion(String query) {
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((UserModel user) {
                String _getUsername = user.displayName.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.displayName.toLowerCase();
                //bool matchesUsername = _getUsername.contains(_query);
                //bool matchesName = _getName.contains(_query);

                //return (matchesUsername || matchesName);
                return true;
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        UserModel searchUser = UserModel(
            id: suggestionList[index].id,
            photoUrl: suggestionList[index].photoUrl,
            displayName: suggestionList[index].displayName,
            username: suggestionList[index].username);

        return CustomTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(receiver: searchUser)));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchUser.photoUrl ??
                  "https://library.kissclipart.com/20181001/wbw/kissclipart-gsmnet-ro-clipart-computer-icons-user-avatar-4898c5072537d6e2.png"),
              backgroundColor: Colors.grey,
            ),
            title: SelectableText(
              searchUser.username,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  textBaseline: TextBaseline.ideographic),
            ),
            subtitle: SelectableText(
              searchUser.displayName,
              style: TextStyle(
                  color: Colors.grey, textBaseline: TextBaseline.ideographic),
            ));
      },
    );
  }
}
