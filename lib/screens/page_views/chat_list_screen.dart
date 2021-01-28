import 'package:assistant_spirit/notification/commit_notification.dart';
import 'package:assistant_spirit/screens/about_dev.dart';
import 'package:assistant_spirit/screens/chatbot_spirit.dart';
import 'package:assistant_spirit/screens/chatscreens/model/contact.dart';
import 'package:assistant_spirit/screens/page_views/widgets/quiet_box.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/screens/page_views/widgets/become_assistant.dart';
import 'package:assistant_spirit/screens/page_views/widgets/contact_view.dart';
import 'package:assistant_spirit/screens/page_views/widgets/user_circle.dart';
import 'package:assistant_spirit/screens/search_screen.dart';
import 'package:assistant_spirit/widgets/appbar.dart';
import 'package:assistant_spirit/widgets/create_route.dart';
import 'package:assistant_spirit/widgets/features.dart';
import 'package:assistant_spirit/widgets/top_bot_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;
  ChatListScreen({this.userId});
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<String> menuOptions = [];

  void initMenu() {
    menuOptions = [
      "Features",
      "Project Repository",
      "About Developer",
      "Sign Out",
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      floatingActionButton: BecomeAssistant(),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Column(
          children: [
            //Top Bot Fade Image
            TopBotAvatar(tag: "assistant-spirit-1"),
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
                            "Bot Assistant",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                textBaseline: TextBaseline.ideographic),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      child: BotChatContainer(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SelectableText(
                            "Human Assistant",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                textBaseline: TextBaseline.ideographic),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.48,
                      width: MediaQuery.of(context).size.width,
                      child: ChatListContainer(),
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

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        title: UserCircle(
          userId: widget.userId,
        ),
        actions: [
          IconButton(
              tooltip: "Search Assistant",
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              }),
          PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_sharp,
                color: Colors.white,
              ),
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return menuOptions.map((String menuOption) {
                  return PopupMenuItem<String>(
                    value: menuOption,
                    child: Text(menuOption),
                  );
                }).toList();
              })
        ],
        leading: IconButton(
          tooltip: "Notifications",
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CommitNotification())),
        ),
        centerTitle: true);
  }

  void _select(String menuOption) async {
    switch (menuOption) {
      case "Features":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Features()));
        break;

      case "Project Repository":
        launch("https://github.com/aniketambore/assistant_spirit");
        break;

      case "About Developer":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutDev()));
        break;

      case "Sign Out":
        logout();
        break;
    }
  }
}

logout() {
  googleSignIn.signOut();
}

class BotChatContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20),
      child: ListTile(
        title: Text(
          "Assistant Spirit",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Arial",
              fontSize: 19,
              textBaseline: TextBaseline.ideographic),
        ),
        subtitle: Text(
          "Hello there!",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              textBaseline: TextBaseline.ideographic),
        ),
        leading: Container(
          constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
          child: Stack(
            children: [
              CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.blueGrey,
                backgroundImage: AssetImage("assets/images/robot.png"),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightGreenAccent,
                      border: Border.all(color: Colors.black, width: 2)),
                ),
              )
            ],
          ),
        ),
        onTap: () => Navigator.of(context)
            .push(CreateRoute.createRoute(AssistantSpirit())),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  Stream<QuerySnapshot> fetchContacts({String userId}) =>
      userRef.document(userId).collection("contacts").snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: fetchContacts(userId: currentUser?.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;
          if (docList.isEmpty) {
            return QuietBox(
              heading: "This is where all the human assistant are listed",
              subtitle:
                  "Search for your personal assitant to start chatting with them",
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: docList.length,
            itemBuilder: (context, index) {
              Contact contact = Contact.fromMap(docList[index].data());
              return ContactView(contact);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
