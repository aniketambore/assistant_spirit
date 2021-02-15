import 'dart:convert';
import 'package:http/http.dart';

class ImageNetwork {
  static const API = "https://api.imagga.com/v2/tags?image_url=";
  static const username = "imagga_username_here";
  static const password = "imagga_password_here";
  static final basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));

  static Future fetchImage(imageUrl) async {
    Response response = await get(Uri.encodeFull(API + "$imageUrl"),
        headers: {"authorization": basicAuth});
    //print("Image url is $imageUrl");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //print(response.statusCode);
    }
  }
}
