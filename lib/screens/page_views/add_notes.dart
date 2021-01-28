import 'dart:async';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/screens/page_views/widgets/card_view.dart';
import 'package:assistant_spirit/screens/page_views/widgets/edit_note.dart';
import 'package:assistant_spirit/widgets/appbar.dart';
import 'package:assistant_spirit/widgets/top_bot_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assistant_spirit/models/user_model.dart';

class AddNotes extends StatefulWidget {
  final String profileId;
  AddNotes({this.profileId});

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes>
    with SingleTickerProviderStateMixin {
  String greetingTime = "";
  String userName = "";

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => startUpJobs(context));
  }

  Future startUpJobs(BuildContext context) async {
    var hr = TimeOfDay.fromDateTime(DateTime.now()).hour;
    setState(() {
      if (hr >= 4 && hr < 12) {
        greetingTime = "Morning";
      } else if (hr >= 12 && hr < 18) {
        greetingTime = "Afternoon";
      } else if (hr >= 6 && hr < 20) {
        greetingTime = "Evening";
      } else {
        greetingTime = "Night";
      }
    });

    prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.containsKey("username")) {
        userName = prefs.getString("username");
      }
    });
    if (prefs.containsKey("first-time")) {
      await prefs.setBool("first-time", false);
    } else {
      await prefs.setBool("first-time", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    addNotesContainer(String nameIS) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.blueGrey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Column(
          children: [
            //Top Bot Fade Image
            TopBotAvatar(
              tag: "assistant-spirit-2",
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Gretting for user
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SelectableText(
                                (greetingTime != "")
                                    ? "Good $greetingTime"
                                    : "",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    textBaseline: TextBaseline.ideographic),
                              ),
                              SelectableText(
                                "$nameIS",
                                style: TextStyle(
                                    color: Colors.lightBlueAccent.shade100,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    textBaseline: TextBaseline.ideographic),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18.0),
                            child: Hero(
                              tag: "add-button",
                              child: Container(
                                height: 66,
                                width: 66,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(33),
                                ),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditNote(autoGen: true)),
                                    );
                                    setState(() {
                                      prefs.getStringList("dataKeys");
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    //Notes Holder
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.48,
                        width: MediaQuery.of(context).size.width,
                        child: prefs != null &&
                                (prefs.getStringList("dataKeys") ?? [])
                                        .length !=
                                    0
                            ? ListView.builder(
                                itemCount: prefs == null
                                    ? 0
                                    : (prefs.getStringList("dataKeys") ?? [])
                                        .length,
                                itemBuilder: (context, int index) {
                                  List<List<String>> data = [];
                                  if (prefs.containsKey('dataKeys')) {
                                    prefs
                                        .getStringList("dataKeys")
                                        .forEach((element) {
                                      data.add(prefs.getStringList(element));
                                    });
                                  }
                                  return Hero(
                                    key: Key(index.toString()),
                                    tag: "edit-button-$index",
                                    child: Material(
                                      key: Key(index.toString()),
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8.0, right: 5, left: 5),
                                        child: CardView(
                                          data: data[index],
                                          id: index,
                                          parent: this,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : EmptyIndicationCard()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          title: SelectableText(
            "Want to remember something ?",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: userRef.document(widget.profileId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            UserModel userModel = UserModel.fromDocument(snapshot.data);
            return addNotesContainer(userModel.username);
          },
        ));
  }
}
