import 'package:assistant_spirit/models/user_model.dart';
import 'package:assistant_spirit/screens/chatscreens/model/contact.dart';
import 'package:assistant_spirit/screens/chatscreens/model/message_model.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/widgets/bar_avatar.dart';
import 'package:assistant_spirit/widgets/calling_action.dart';
import 'package:assistant_spirit/widgets/create_route.dart';
import 'package:assistant_spirit/widgets/message_toast.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;
  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;

  void sendMessage(String senderMessage) {
    var text = textFieldController.text;
    MessageModel _message = MessageModel(
        receiverId: widget.receiver.id,
        senderId: currentUser.id,
        message: text,
        timestamp: Timestamp.now(),
        type: "text");

    setState(() {
      textFieldController.clear();
      isWriting = false;
      addMessageToDb(_message, currentUser, widget.receiver);
    });
  }

  Future<void> addMessageToDb(
      MessageModel message, UserModel sender, UserModel receiver) async {
    var map = message.toMap();
    await Firestore.instance
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await Firestore.instance
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  // Adding the sender and receiver to each others contact list.
  DocumentReference getContactsDocument({String of, String forContact}) =>
      userRef.document(of).collection("contacts").document(forContact);

  Future<void> addToSenderContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exists
      Contact receiverContact = Contact(uid: receiverId, addedOn: currentTime);

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exists
      Contact senderContact = Contact(uid: senderId, addedOn: currentTime);

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(
            child: messageList(),
          ),
          chatControls()
        ],
      ),
    );
  }

  AppBar customAppBar(contex) {
    return AppBar(
      leading: IconButton(
        tooltip: "Back",
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.black54),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BarAvatar(
            isBot: false,
            isHuman: true,
            url: "${widget.receiver.photoUrl}",
          ),
          SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${widget.receiver.username}",
              ),
            ],
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          tooltip: "Voice Call",
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {
            // launch("http://developer-aniket_ambore.surge.sh/#/");
            Navigator.of(context).push(CreateRoute.createRoute(CallingAction(
              isBot: false,
              isHuman: true,
              name: "${widget.receiver.username}",
              url: "${widget.receiver.photoUrl}",
              isVoiceCall: true,
            )));
          },
        ),
        IconButton(
          tooltip: "Video Call",
          icon: Icon(Icons.videocam),
          onPressed: () {
            // launch("http://developer-aniket_ambore.surge.sh/#/");
            Navigator.of(context).push(CreateRoute.createRoute(CallingAction(
              isBot: false,
              isHuman: true,
              name: "${widget.receiver.username}",
              url: "${widget.receiver.photoUrl}",
              isVoiceCall: false,
            )));
          },
        ),
        IconButton(
          tooltip: "Options",
          icon: Icon(Icons.more_vert_sharp),
          onPressed: () {
            //launch("http://developer-aniket_ambore.surge.sh/#/");
          },
        ),
      ],
    );
  }

  Widget chatControls() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      color: Colors.blueGrey)
                ],
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                      tooltip: "Emoji Picker",
                      icon: Icon(Icons.face),
                      onPressed: () {
                        MessageToast.showToast(
                            "Emoji Picker is not available.", context);
                      }),
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                      onSubmitted: sendMessage,
                    ),
                  ),
                  IconButton(
                    tooltip: "Image Picker",
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      MessageToast.showToast(
                          "You cannot send any images to human assistant.",
                          context);
                    },
                  ),
                  IconButton(
                      tooltip: "Attachment Picker",
                      icon: Icon(Icons.attach_file),
                      onPressed: () {
                        MessageToast.showToast(
                            "You cannot attach any file to human assistant.",
                            context);
                      })
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            child: InkWell(
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
              onTap: () {
                if (textFieldController.text.trim().isEmpty) {
                  MessageToast.showToast("Enter Some Message!", context);
                } else {
                  //
                  sendMessage(textFieldController.text);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("messages")
          .document(currentUser.id)
          .collection(widget.receiver.id)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    MessageModel _message = MessageModel.fromMap(snapshot.data());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == currentUser.id
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == currentUser.id
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(MessageModel messageModel) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Bubble(
                      radius: Radius.circular(15.0),
                      color: Colors.orangeAccent,
                      elevation: 0.0,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: 5.0,
                            ),
                            Flexible(
                                child: Container(
                              constraints: BoxConstraints(maxWidth: 170),
                              child: getMessage(messageModel),
                            ))
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          BarAvatar(
            isBot: false,
            isHuman: true,
            url: "${photoUrl}",
          ),
        ],
      ),
    );
  }

  Widget receiverLayout(MessageModel messageModel) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: new Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BarAvatar(
          isBot: false,
          isHuman: true,
          url: "${widget.receiver.photoUrl}",
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Bubble(
                    radius: Radius.circular(15.0),
                    color: Color.fromRGBO(23, 157, 139, 1),
                    elevation: 0.0,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          Flexible(
                              child: Container(
                            constraints: BoxConstraints(maxWidth: 170),
                            child: getMessage(messageModel),
                          ))
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  getMessage(MessageModel messageModel) {
    return SelectableText(
      messageModel.message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
