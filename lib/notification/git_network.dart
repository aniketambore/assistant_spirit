import 'dart:convert';
import 'package:http/http.dart';

class GitNetwork {
  static const API =
      "https://api.github.com/repos/username/reopsitory/commits?access_token=";
  static const outhToken = "access_token";

  static Future fetchCommit() async {
    Response response = await get(API + "$outhToken");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // print(response.statusCode);
      // print(response.body);
      return json.decode(response.body);
    }
  }
}
