import 'dart:async';
import 'package:assistant_spirit/networks/image_detecting.dart';
import 'package:assistant_spirit/screens/about_dev.dart';
import 'package:assistant_spirit/screens/home_page.dart';
import 'package:assistant_spirit/widgets/bar_avatar.dart';
import 'package:assistant_spirit/widgets/calling_action.dart';
import 'package:assistant_spirit/widgets/create_route.dart';
import 'package:assistant_spirit/widgets/features.dart';
import 'package:assistant_spirit/widgets/message_toast.dart';
import 'package:assistant_spirit/widgets/select_language.dart';
import 'package:assistant_spirit/widgets/spirit_message.dart';
import 'package:assistant_spirit/widgets/url_web_view.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';
import 'package:translator/translator.dart';
import 'package:image/image.dart' as Im;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//import 'dart:io';
import 'package:firebase/firebase.dart' as fb;
import 'dart:html';

class AssistantSpirit extends StatefulWidget {
  @override
  _AssistantSpiritState createState() => _AssistantSpiritState();
}

enum TtsState { playing, stopped }

class _AssistantSpiritState extends State<AssistantSpirit> {
  FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  String _newVoiceText;

  get isPlaying => _ttsState == TtsState.playing;
  get isStopped => _ttsState == TtsState.stopped;

  List<String> menuOptions = [];
  final messageTextController = TextEditingController();
  bool botAnswered = true;
  final List<SpiritMessage> _messages = <SpiritMessage>[];

  bool showEmojiPicker = false;
  FocusNode messageTextFocus = FocusNode();

  //File _imageAndroid;

  Future postingImage;
  String postId = Uuid().v4();
  firebase_storage.StorageReference storageRef = FirebaseStorage.instance.ref();

  String _imageWebUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _response("hi there", true);
    _initTts();
    initMenu();
  }

  _initTts() async {
    _flutterTts = FlutterTts();

    // LISTENING FOR PLATFORM CALLS
    _flutterTts.setStartHandler(() {
      setState(() {
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        if (await _flutterTts.speak(_newVoiceText) == 1)
          setState(() => _ttsState = TtsState.playing);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _flutterTts.stop();
    super.dispose();
  }

  void initMenu() {
    menuOptions = [
      "Change Language",
      "Features",
      "Project Repository",
      "About Developer",
    ];
  }

  void _select(String menuOption) async {
    switch (menuOption) {
      case "Change Language":
        Navigator.of(context).push(CreateRoute.createRoute(SelectLanguage()));
        break;

      case "Features":
        Navigator.of(context).push(CreateRoute.createRoute(Features()));
        break;

      case "Project Repository":
        launch("https://github.com/aniketambore/assistant_spirit");
        break;

      case "About Developer":
        Navigator.of(context).push(CreateRoute.createRoute(AboutDev()));
        break;
    }
  }

  void _question(String userQuestion) async {
    //1). Translating the userQuestion into english and storing the english context in enTranslate.
    //2). Passing the userQuestion to SpiritMessage() for UI chat build up.
    //3). Passing ```enTranslate``` value to _response()

    var enTranslate;
    if (userQuestion.trim().isNotEmpty) {
      //  if (botAnswered) {
      SpiritMessage message;

//      if (_imageAndroid != null) {
//        message = SpiritMessage(
//          image: _imageAndroid,
//          type: true,
//        );
//      }
//      else
      if (_imageWebUrl != "") {
        message = SpiritMessage(
          imageWeb: _imageWebUrl,
          type: true,
        );
      } else {
        messageTextController.clear();
        enTranslate = (await userQuestion.translate(to: 'en'));
        message = SpiritMessage(
            text: userQuestion,
            type: true,
            avatarImage:
                "https://miro.medium.com/max/1033/1*MAsNORFL89roPfIFMBnA4A.jpeg");
      }
      setState(() {
        _messages.insert(0, message);
        botAnswered = false;
      });

      _response("$enTranslate", false);
//      }
//      else {
//        MessageToast.showToast("Wait for Spirit to respond", context);
//      }
    }
  }

  void _response(query, bool welcomeMessage) async {
    //1). Dialogflow Credentials Importing.
    //2). Passing the query(i.e userQuestion) to dialogflow agent.
    //3). Passing the dialogflow gathered aiResponse to _sendResponse().

//    if (_imageAndroid != null) {
//      List imageTag = [];
//      await compressImageAndroid();
//
//      ImageNetwork.fetchImage(await uploadImage(_imageAndroid)).then((value) {
//        for (var i = 0; i < 10; i++) {
//          imageTag.add("${value["result"]["tags"][i]["tag"]["en"]}");
//        }
//
//        _sendResponse("It looks like $imageTag");
//      }).catchError((err) {
//        _sendResponse("$err");
//      });
//    }
//    else
    if (_imageWebUrl != "") {
      List imageTag = [];

      ImageNetwork.fetchImage(_imageWebUrl).then((value) {
        for (var i = 0; i < 10; i++) {
          imageTag.add("${value["result"]["tags"][i]["tag"]["en"]}");
        }

        _sendResponse("It looks like $imageTag");
      }).catchError((err) {
        _sendResponse("$err");
      });

      // _sendResponse("Image Web");
    } else {
      messageTextController.clear();

      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: "assets/credentials.json").build();

      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.english);

      AIResponse aiResponse = await dialogflow.detectIntent(query);

      if (welcomeMessage) {
        _sendResponse(
            //"${aiResponse.getListMessage()[0]["text"]["text"][0].toString()}");
            "${aiResponse.getMessage()}");
      } else {
        handleResponse(aiResponse);
//            .then((onValue) {
//          if (!onValue) _sendResponse(aiResponse.getMessage());
//        });

        _sendResponse(
            //"${aiResponse.getListMessage()[0]["text"][0].toString()}");
            "${aiResponse.getMessage()}");
      }
    }
  }

  void _sendResponse(String _response) async {
    //1). Getting the userSelected language from SelectLanguage() and storing it in myValue.
    //2). Setting the tts language to myValue.
    //3). Translating the _response(englishLanguage context) to myValue(userSelectedLanguage).
    //4). Storing the userDefinedLanguage value in var resp
    //4). Passing the translated(resp) to SpiritMessage() for ui build up.
    //5). Setting the _newVoiceText to resp.
    //6). calling _speak() for text to speech.

    String myValue = await Settings().getString(
      'radiokey',
      'en',
    );

    if (await _flutterTts.isLanguageAvailable(myValue)) {
      await _flutterTts.setLanguage(myValue);
    }

    var resp;

//    if (_imageAndroid != null) {
//      resp = (await _response.translate(to: myValue));
//    }
    //   else
    if (_imageWebUrl != "") {
      resp = (await _response.translate(to: myValue));
    } else {
      resp = (await _response.translate(to: myValue));
    }

    //_imageAndroid = null;
    _imageWebUrl = "";

    SpiritMessage message = SpiritMessage(
      text: "$resp",
      type: false,
    );

    _newVoiceText = "$resp";

    setState(() {
      _messages.insert(0, message);
      botAnswered = true;
    });

    _speak();
  }

  showKeyboard() => messageTextFocus.requestFocus();

  hideKeyboard() => messageTextFocus.unfocus();

  hideEmojiConatiner() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiConatiner() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.black54),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BarAvatar(
              isBot: true,
              isHuman: false,
              url: "assets/images/robot.png",
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bot Spirit",
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.black),
                  overflow: TextOverflow.clip,
                ),
                Text(
                  "Online",
                  style: Theme.of(context).textTheme.subtitle.apply(
                        color: Colors.lightGreenAccent,
                      ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip: "Voice Call",
            icon: Icon(Icons.phone),
            onPressed: () {
              Navigator.of(context).push(CreateRoute.createRoute(CallingAction(
                isBot: true,
                isHuman: false,
                name: "Assistant Spirit",
                url: "assets/images/robot.png",
                isVoiceCall: true,
              )));
            },
          ),
          IconButton(
            tooltip: "Video Call",
            icon: Icon(Icons.videocam),
            onPressed: () {
              Navigator.of(context).push(CreateRoute.createRoute(CallingAction(
                isBot: true,
                isHuman: false,
                name: "Assistant Spirit",
                url: "assets/images/robot.png",
                isVoiceCall: false,
              )));
            },
          ),
          PopupMenuButton<String>(
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
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    "Today, ${DateFormat("Hm").format(DateTime.now())}",
                    //DateFormat.yMEd().add_jms().format(DateTime.now())
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Flexible(
                    //child: Container(),
                    child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) => _messages[index],
                )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
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
                                  onPressed: () => MessageToast.showToast(
                                      "Emoji is not available.", context)),
                              Expanded(
                                child: TextField(
                                  onTap: () => hideEmojiConatiner(),
                                  focusNode: messageTextFocus,
                                  controller: messageTextController,
                                  style: TextStyle(height: 1.3),
                                  decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      border: InputBorder.none,
                                      helperStyle: TextStyle(height: 1.3)),
                                  onSubmitted: _question,
                                ),
                              ),
                              IconButton(
                                tooltip: "Image Picker",
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {
                                  uploadToStorageWeb();
                                  //selectImage(context);
                                },
                              ),
                              IconButton(
                                  tooltip: "Attachments",
                                  icon: Icon(Icons.attach_file),
                                  onPressed: () {
                                    uploadToStorageWeb();
                                    //selectImage(context);
                                  })
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: InkWell(
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          onTap: () {
                            if (messageTextController.text.trim().isEmpty) {
                              MessageToast.showToast(
                                  "Enter Some Message!", context);
                            } else {
                              _question(messageTextController.text);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                showEmojiPicker
                    ? Container(
                        child: emojiContainer(),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  logout() {
    googleSignIn.signOut();
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.black54,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 20,
      onEmojiSelected: (emoji, category) {
        messageTextController.text = messageTextController.text + emoji.emoji;
      },
    );
  }

//  selectImage(parentContext) {
//    return showDialog(
//        context: parentContext,
//        builder: (context) {
//          return SimpleDialog(
//            title: Text("Select Source"),
//            children: [
//              SimpleDialogOption(
//                child: Text("Photo with camera"),
//                onPressed: () => pickImageAndroid(source: ImageSource.camera),
//              ),
//              SimpleDialogOption(
//                child: Text("Image from Gallery"),
//                onPressed: () => pickImageAndroid(source: ImageSource.gallery),
//              ),
//              SimpleDialogOption(
//                child: Text("Cancel"),
//                onPressed: () => Navigator.pop(context),
//              )
//            ],
//          );
//        });
//  }
//
//  pickImageAndroid({@required ImageSource source}) async {
//    Navigator.pop(context);
//    File file = await ImagePicker.pickImage(
//        source: source, maxWidth: 960, maxHeight: 675);
//
//    if (file != null) {
//      setState(() {
//        this._imageAndroid = file;
//      });
//    }
//
//    _question("query");
//  }
//
////
//  compressImageAndroid() async {
//    final tempDir = await getTemporaryDirectory();
//    final path = tempDir.path;
//
//    Im.Image imageFile = Im.decodeImage(_imageAndroid.readAsBytesSync());
//
//    final compressedImageFile = File("$path/img_$postId.jpg")
//      ..writeAsBytes(Im.encodeJpg(imageFile, quality: 85));
//
//    setState(() {
//      _imageAndroid = compressedImageFile;
//    });
//  }
//
//  Future<String> uploadImage(imageFile) async {
//    try {
//      StorageUploadTask uploadTask =
//          storageRef.child("Post_$postId.jpg").putFile(imageFile);
//
//      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//
//      String downloadUrl = await storageSnap.ref.getDownloadURL();
//
//      return downloadUrl;
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }

  uploadImageWeb({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoad.listen((event) {
        //print("done");
        onSelected(file);
      });
    });
  }

  uploadToStorageWeb() async {
    final dateTime = DateTime.now();
    final path = "${currentUser.id}/${currentUser.username}/$dateTime.jpg";
    uploadImageWeb(onSelected: (file) {
      fb
          .storage()
          .refFromURL("gs://assistant-spirit.appspot.com")
          .child(path)
          .put(file)
          .future
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          if (value != null) {
            setState(() {
              this._imageWebUrl = value.toString();
            });
          }
          _question("query");
        });
      });
    });
  }

  String chooseLocation(Map param) {
    if (param['city'].toString().isNotEmpty)
      return param['city'].toString();
    else if (param['island'].toString().isNotEmpty)
      return param['island'].toString();
    else if (param['shortcut'].toString().isNotEmpty)
      return param['shortcut'].toString();
    else if (param['street-address'].toString().isNotEmpty)
      return param['street-address'].toString();
    else if (param['business-name'].toString().isNotEmpty)
      return param['business-name'].toString();
    else if (param['subadmin-area'].toString().isNotEmpty)
      return param['subadmin-area'].toString();
    else if (param['zip-code'].toString().isNotEmpty)
      return param['zip-code'].toString();
    else if (param['country'].toString().isNotEmpty)
      return param['country'].toString();
    else if (param['admin-area'].toString().isNotEmpty)
      return param['admin-area'].toString();
    return param['city'].toString();
  }

  Future<bool> handleResponse(AIResponse response) async {
    switch (response.queryResult.action) {
      //Set Alarm Action Intent
      case "alarm.set":
        if (response.queryResult.parameters["time"].toString().isNotEmpty) {
          var hour =
              "${int.parse(response.queryResult.parameters["time"].toString().substring(11, 13))}";
          var minutes =
              "${int.parse(response.queryResult.parameters["time"].toString().substring(14, 16))}";
          var title = response.queryResult.parameters["alarm-name"] ?? "";

          var url = "https://vclock.com/#time=$hour:$minutes&title=$title";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlWebView(
                        url: url,
                        barName: "Online Alarm",
                      )));
        } else
          return false;
        break;

      //Check Alarm Action Intent
      case "alarm.check":
        var checkUrl = "https://vclock.com";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UrlWebView(
                      url: checkUrl,
                      barName: "Check Alarm",
                    )));
        break;

      //Set Timer Action Intent
      case "timer.set":
        if (response.queryResult.parameters['seconds'].toString().isNotEmpty) {
          var sec = "${response.queryResult.parameters['seconds'].toString()}";

          var timerUrl = "https://vclock.com/timer/#countdown=00:00:$sec";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlWebView(
                        url: timerUrl,
                        barName: "Set Timer",
                      )));
        } else
          return false;
        break;

      //Start a stopwatch action intent
      case "stopwatch":
        var stopwatchUrl = "https://vclock.com/stopwatch/#";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UrlWebView(
                      url: stopwatchUrl,
                      barName: "Stopwatch",
                    )));

        break;

      //Add Contacts Online
      case "contact.insert":
        var contactUrl = "https://contacts.google.com";

        if (await canLaunch(contactUrl))
          await launch(contactUrl);
        else
          _response("intentFail", false);
        break;

      //Search in dictionary
      case "dictionary.find":
        if (response.queryResult.parameters['word'].toString().isNotEmpty) {
          var wordToSearch =
              "${response.queryResult.parameters['word'].toString()}";
          var dictionaryUrl =
              "https://www.merriam-webster.com/dictionary/$wordToSearch";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlWebView(
                        url: dictionaryUrl,
                        barName: "Dictionary",
                      )));
        } else
          return false;
        break;

      //Send Email
      case "email.send":
        if (response.queryResult.parameters['email'].toString().isNotEmpty &&
            response.queryResult.parameters['text'].toString().isNotEmpty) {
          var url = 'mailto:' +
              response.queryResult.parameters['email'] +
              '?subject=' +
              response.queryResult.parameters['subject'] +
              '&body=' +
              response.queryResult.parameters['text'];

          if (await canLaunch(url))
            await launch(url);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //Generate Lyrics
      case "song.lyrics":
        if (response.queryResult.parameters['song'].toString().isNotEmpty) {
          var songToSearch =
              "${response.queryResult.parameters['song'].toString()}";

          var geniusUrl =
              "https://search.azlyrics.com/search.php?q=$songToSearch";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlWebView(
                        url: geniusUrl,
                        barName: "Search Lyrics",
                      )));
        } else
          return false;
        break;

      //Search location in map
      case "maps.search":
        if (response.queryResult.parameters['location'].toString().isNotEmpty) {
          var urlMap =
              "https://www.google.com/maps/search/${chooseLocation(response.queryResult.parameters['location'])}}";

          if (await canLaunch(urlMap))
            await launch(urlMap);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //For Navigation
      case "navigation":
        if (response.queryResult.parameters['location'].toString().isNotEmpty) {
          var url =
              "https://www.google.com/maps/search/${chooseLocation(response.queryResult.parameters['location'])}";
          if (await canLaunch(url))
            await launch(url);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //For News
      case "news.search":
        if (response.queryResult.parameters['category'].toString().isNotEmpty) {
          var newsCategory =
              "${response.queryResult.parameters['category'].toString()}";
          var newsUrl = "https://www.bbc.co.uk/search?q=$newsCategory";

          if (await canLaunch(newsUrl))
            await launch(newsUrl);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //Send Sms Action Intent
      case "sms":
        if (response.queryResult.parameters['phone-number']
                .toString()
                .isNotEmpty &&
            response.queryResult.parameters['text'].toString().isNotEmpty) {
          var url = 'sms:' +
              response.queryResult.parameters['phone-number'] +
              '?body=' +
              response.queryResult.parameters['text'];
          if (await canLaunch(url))
            await launch(url);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //Crypto Currency Conversion
      case "crypto.convert":
        if (response.queryResult.parameters['currency-name']
                .toString()
                .isNotEmpty &&
            response.queryResult.parameters['crypto-name']
                .toString()
                .isNotEmpty &&
            response.queryResult.parameters['number'].toString().isNotEmpty) {
          var fiatCurrency =
              "${response.queryResult.parameters['currency-name'].toString()}";

          var cryptoCurrency =
              "${response.queryResult.parameters['crypto-name'].toString()}";

          var count = "${response.queryResult.parameters['number'].toString()}";

          var cryptoUrl =
              "https://coinmarketcap.com/converter/$cryptoCurrency/$fiatCurrency/?amt=$count";

          if (await canLaunch(cryptoUrl))
            await launch(cryptoUrl);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //For Weather
      case "weather":
        var weatherUrl = "https://www.ventusky.com";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UrlWebView(
                      url: weatherUrl,
                      barName: "Current Weather",
                    )));
        break;

      //Web Search online
      case "web.search":
        if (response.queryResult.parameters["toSearch"].toString().isNotEmpty) {
          var toSearch =
              "${response.queryResult.parameters["toSearch"].toString()}";

          var url = "https://duckduckgo.com/?q=$toSearch";

          if (await canLaunch(url))
            await launch(url);
          else
            _response("intentFail", false);
        } else
          return false;
        break;

      //For Web Page Search
      case "web_page":
        var toSearch = "${response.queryResult.parameters["url"].toString()}";
        var url = "https://duckduckgo.com/?q=$toSearch";

        if (await canLaunch(url))
          await launch(url);
        else
          _response("intentFail", false);
        break;

      //For Free Courses
      case "course.free":
        if (response.queryResult.parameters['course-name']
            .toString()
            .isNotEmpty) {
          var courseName =
              "${response.queryResult.parameters['course-name'].toString()}";

          var freeCourseUrl = "https://www.techwithtim.net/?s=$courseName";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UrlWebView(
                        url: freeCourseUrl,
                        barName: "Free Courses",
                      )));
        } else
          return false;
        break;

      default:
        return false;
    }
    botAnswered = true;
    return true;
  }
}
