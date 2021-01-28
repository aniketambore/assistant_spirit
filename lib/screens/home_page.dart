import 'package:assistant_spirit/models/user_model.dart';
import 'package:assistant_spirit/screens/create_username.dart';
import 'package:assistant_spirit/screens/page_views/add_notes.dart';
import 'package:assistant_spirit/screens/page_views/available_assistant.dart';
import 'package:assistant_spirit/screens/page_views/chat_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

UserModel currentUser;
final GoogleSignIn googleSignIn = GoogleSignIn();
final userRef = Firestore.instance.collection("users");
String photoUrl =
    "https://cdn4.iconfinder.com/data/icons/instagram-ui-twotone/48/Paul-18-512.png";
String userName = "user";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      //print("Error Signing In: $err");
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }, onError: (err) {
      //print("Error Signing In: $err");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      //print("User Signed -In $account");
      createUserInFirestore();
      setState(() {
        _isAuth = true;
      });
    } else {
      setState(() {
        _isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    //1) Check if user exists in user collection in database according to their id
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await userRef.document(user.id).get();

    if (!doc.exists) {
      //2) If the user doesn't exist then create it.
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateUsernameScreen()));

      userRef.document(user.id).setData({
        "id": user.id,
        "displayName": user.displayName,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "timestamp": DateTime.now(),
        "isAssistant": false
      });

      doc = await userRef.document(user.id).get();
    }

    currentUser = UserModel.fromDocument(doc);
    // print(currentUser.displayName);
    //print(currentUser.photoUrl);

    setState(() {
      photoUrl = "${currentUser.photoUrl}";
      userName = "${currentUser.username}";
    });
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          ChatListScreen(
            userId: currentUser?.id,
          ),
          AddNotes(
            profileId: currentUser?.id,
          ),
          AvailableAssistant()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_add_outlined), label: "Notes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind_sharp), label: "Assistant"),
        ],
      ),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xffFDCF09),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage('assets/images/robot.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SelectableText(
                    "Assistant Spirit",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    child: Container(
                      width: 260,
                      height: 60,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 1),
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/google_sign.png"),
                              fit: BoxFit.cover)),
                    ),
                    onTap: login,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth == true ? buildAuthScreen() : buildUnAuthScreen();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
