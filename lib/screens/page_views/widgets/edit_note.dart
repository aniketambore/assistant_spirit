import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNote extends StatefulWidget {
  EditNote({Key key, this.data, this.autoGen, this.id}) : super(key: key);

  bool autoGen;
  final data;
  final int id;

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote>
    with SingleTickerProviderStateMixin {
  List<String> data = [
    "",
    "0",
    "",
    "",
    "",
  ];
  bool explodeColoredCircle = false;
  bool showInputSection1 = false;
  bool showInputSection2 = false;
  String saveStatus = "";
  TextEditingController _headingController = TextEditingController(),
      _bodyController = TextEditingController();
  SharedPreferences prefs;

  final monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];

  void autoAssignData() {
    var now = DateTime.now();
    data = [
      "",
      "Colors.purple",
      "${now.day}".padLeft(2, "0"),
      "${monthNames[now.month]}",
      "${now.year}",
      "",
    ];
  }

  void animationGo(BuildContext context) async {
    if (widget.autoGen == true) {
      autoAssignData();
    } else {
      data = widget.data;
      _headingController.text = data[0];
      _bodyController.text = data[5];
    }

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        explodeColoredCircle = true;
      });
    });

    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        showInputSection1 = true;
      });
    });
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        showInputSection2 = true;
      });
    });

    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => animationGo(context));
  }

  void deleteJournal(int index) async {
    var timestamps = prefs.getStringList("dataKeys");
    var _toRemoveData = timestamps[index];
    timestamps.removeAt(index);
    await prefs.setStringList("dataKeys", timestamps);
    await prefs.remove(_toRemoveData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.autoGen == true
            ? "add-button"
            : widget.autoGen == null
                ? "edit-button-${widget.id}"
                : "",
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black54, Colors.blueGrey],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight)),
          child: Stack(
            children: <Widget>[formFields(), dateContainer(), popDeleteNote()],
          ),
        ),
      ),
    );
  }

  //Two TextFields with the submit button
  Widget formFields() {
    return Material(
      textStyle: TextStyle(
          color: Colors.teal,
          fontSize: 30,
          fontWeight: FontWeight.w900,
          textBaseline: TextBaseline.ideographic),
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 400),
              height: 190 + (showInputSection1 ? 0.0 : 100.0),
            ),
            AnimatedOpacity(
              curve: Curves.easeIn,
              opacity: showInputSection1 ? 1 : 0,
              duration: Duration(milliseconds: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText("Title"),
                  SizedBox(height: 7),
                  TextField(
                    controller: _headingController,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        color: Colors.green.shade500,
                        fontSize: 25,
                        textBaseline: TextBaseline.ideographic),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.teal,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 400),
              height: 30 + (showInputSection2 ? 0.0 : 100.0),
            ),
            AnimatedOpacity(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 400),
              opacity: showInputSection2 ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText("Describe it, if you may!"),
                  SizedBox(height: 7),
                  TextField(
                    controller: _bodyController,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        color: Colors.green.shade500,
                        fontSize: 22,
                        textBaseline: TextBaseline.ideographic),
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.teal,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FlatButton(
              onPressed: () async {
                if (_headingController.text.trim() == "" ||
                    _bodyController.text.trim() == "") {
                  return null;
                }
                if (widget.autoGen == true) {
                  var journalDataKeys = prefs.getStringList("dataKeys") ?? [];
                  var timeStamp = DateTime.now().toIso8601String();
                  data[0] = _headingController.text;
                  data[5] = _bodyController.text;

                  journalDataKeys.insert(0, "data_$timeStamp");
                  await prefs.setStringList("dataKeys", journalDataKeys);
                  await prefs.setStringList("data_$timeStamp", data);
                  Navigator.pop(context);
                } else {
                  var timestamp = prefs.getStringList("dataKeys")[widget.id];
                  data = prefs.getStringList(timestamp);
                  data[0] = _headingController.text;
                  data[5] = _bodyController.text;

                  await prefs.setStringList(timestamp, data);
                  Navigator.pop(context);
                }
                setState(() {
                  saveStatus = "Untitled";
                  widget.autoGen = false;
                });
              },
              child: Text(
                "SAVE",
                style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.tealAccent,
                    textBaseline: TextBaseline.ideographic),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //Right Corner Date Container
  Widget dateContainer() {
    return Positioned(
      top: -95,
      right: -125,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.fastLinearToSlowEaseIn,
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: explodeColoredCircle ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(150),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(right: 15, left: 48, bottom: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                data[2],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                data[3],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              Text(
                data[4],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Cross Or Delete the existing note
  Widget popDeleteNote() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 140,
        width: 70,
        child: ListView(
          scrollDirection: Axis.vertical,
          reverse: true,
          children: <Widget>[
            SizedBox(
              height: 70,
              width: 70,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 27),
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.close, size: 40, color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            widget.autoGen == true
                ? Container()
                : SizedBox(
                    height: 70,
                    width: 70,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, top: 47),
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.delete,
                            size: 40, color: Colors.redAccent),
                      ),
                      onTap: () {
                        setState(() {
                          widget.autoGen = false;
                        });
                        deleteJournal(widget.id);
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
