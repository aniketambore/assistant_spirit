import 'package:assistant_spirit/screens/page_views/widgets/edit_note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardView extends StatefulWidget {
  CardView({Key key, @required this.data, this.id, this.parent});

  final List<String> data;
  final int id;
  final parent;

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    var text = widget.data[0];
    var date = widget.data.sublist(2);

    return Stack(
      children: [
        InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            margin: EdgeInsets.only(left: 60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.blueGrey,
                elevation: 4.5,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 54.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${text}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            textBaseline: TextBaseline.ideographic),
                      ),
                      Text("${date[0]} ${date[1]} ${date[2]}")
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    EditNote(data: widget.data, id: widget.id),
              ),
            );
            widget.parent.setState(() {
              prefs.getStringList("dataKeys");
            });
          },
        ),
        Positioned(
          top: 10,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                    image: AssetImage("assets/images/robot.png"),
                    fit: BoxFit.cover)),
          ),
        )
      ],
    );
  }
}

class EmptyIndicationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.88,
      widthFactor: 0.68,
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditNote(autoGen: true)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.black54,
                      size: 50,
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.black54,
                      size: 100,
                    ),
                  ],
                ),
                Icon(
                  Icons.notes_sharp,
                  color: Colors.black54,
                  size: 90,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
