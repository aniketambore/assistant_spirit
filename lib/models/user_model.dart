import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String username;
  String email;
  String photoUrl;
  String displayName;
  bool isAssistant;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.photoUrl,
      this.displayName,
      this.isAssistant});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc.id,
        email: doc.data()["email"],
        photoUrl: doc.data()["photoUrl"],
        username: doc.data()["username"],
        displayName: doc.data()["displayName"],
        isAssistant: doc.data()["isAssistant"]);
  }

  Map toMap(UserModel user) {
    var data = Map<String, dynamic>();
    data["id"] = user.id;
    data["email"] = user.email;
    data["username"] = user.username;
    data["displayName"] = user.displayName;
    data["photoUrl"] = user.photoUrl;
    data["isAssistant"] = user.isAssistant;

    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData["id"];
    this.username = mapData["username"];
    this.email = mapData["email"];
    this.displayName = mapData["displayName"];
    this.photoUrl = mapData["photoUrl"];
    this.isAssistant = mapData["isAssistant"];
  }
}
