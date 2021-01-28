import 'package:assistant_spirit/models/user_model.dart';
import 'package:assistant_spirit/screens/chatscreens/chat_screen.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/screens/page_views/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> users = List<UserModel>();
    QuerySnapshot querySnapshot =
        await userRef.where("isAssistant", isEqualTo: true).getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.id) {
        users.add(UserModel.fromMap(querySnapshot.documents[i].data()));
      }
    }
    return users;
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
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestion(query),
      ),
    );
  }

  searchAppBar(BuildContext context) {
    return AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor
          ])),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 10),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
              cursorColor: Colors.black,
              autofocus: true,
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => searchController.clear(),
                ),
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0X8ffffff)),
              ),
            ),
          ),
        ));
  }

  buildSuggestion(String query) {
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((UserModel user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.displayName.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        UserModel searchedUser = UserModel(
            id: suggestionList[index].id,
            photoUrl: suggestionList[index].photoUrl,
            displayName: suggestionList[index].displayName,
            username: suggestionList[index].username);

        return CustomTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(receiver: searchedUser)));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.photoUrl ??
                  "https://library.kissclipart.com/20181001/wbw/kissclipart-gsmnet-ro-clipart-computer-icons-user-avatar-4898c5072537d6e2.png"),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              searchedUser.username,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              searchedUser.displayName,
              style: TextStyle(color: Colors.grey),
            ));
      },
    );
  }
}
