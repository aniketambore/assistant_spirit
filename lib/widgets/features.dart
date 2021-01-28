import 'package:flutter/material.dart';

class Features extends StatefulWidget {
  @override
  _FeaturesState createState() => _FeaturesState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _FeaturesState extends State<Features> {
  List<NewItem> items = <NewItem>[
    NewItem(
        false,
        'Change Languages',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature21.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.language) // iconPic
        ),
    NewItem(
        false,
        'CryptoCurrency Conversion',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature8.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.money_sharp) // iconPic
        ),
    NewItem(
        false,
        'Current Weather',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature13.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.cloud) // iconPic
        ),
    NewItem(
        false,
        'Dictionary',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature11.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.library_books) // iconPic
        ),
    NewItem(
        false,
        'Detect Image',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature22.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.image) // iconPic
        ),
    NewItem(
        false,
        'Direct Navigation',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature9.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.not_listed_location_outlined) // iconPic
        ),
    NewItem(
        false,
        'Free Online courses',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature14.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.laptop) // iconPic
        ),
    NewItem(
        false,
        'Human Assistant',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature23.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.supervised_user_circle) // iconPic
        ),
    NewItem(
        false,
        'Jokes and Quotes',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature17.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.format_quote) // iconPic
        ),
    NewItem(
        false,
        'News',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature10.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.pages) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Set Alarms', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature4.jpg"),
          ),
        ), // body
        Icon(Icons.alarm_add) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Fetch Alarms', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature5.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.alarm_on) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Set Timer', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature6.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.timer) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Search Lyrics', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature7.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.queue_music) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Send Email / Send Sms', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature12.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.mail) // iconPic
        ),
    NewItem(
        false, // isExpanded ?
        'Search On Map', // header
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature15.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.map) // iconPic
        ),
    NewItem(
        false,
        'Web Search',
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.lightGreenAccent,
              width: 10,
            ),
          ),
          child: Image(
            image: AssetImage("assets/features/feature20.jpg"),
            fit: BoxFit.cover,
          ),
        ), // body
        Icon(Icons.search) // iconPic
        ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Features"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  items[index].isExpanded = !items[index].isExpanded;
                });
              },
              children: items.map((NewItem item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        leading: item.iconpic,
                        title: Text(
                          item.header,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ));
                  },
                  isExpanded: item.isExpanded,
                  body: item.body,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
