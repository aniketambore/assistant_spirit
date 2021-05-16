import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class VaccineAPI {
  static const vaccineAPI =
      "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=";
  //"https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=400020&date=01-04-2021";

  static Future getVaccine(pincode, vaccineDate) async {
//    final now = new DateTime.now();
//    String formatter = "${now.day}-${now.month}-${now.year}"; // 28/03/2020
//    print("Today's date is $formatter");
    print("Url is $vaccineAPI$pincode&date=$vaccineDate");

    Response response =
        await get(Uri.encodeFull("$vaccineAPI$pincode&date=$vaccineDate"));
    if (response.statusCode == 200) {
      print(json.decode(response.body)["sessions"]);
      List data = json.decode(response.body)["sessions"];
      if (data.isEmpty) {
        print("Yes blank");
        return "Brrrrr";
      } else {
        return json.decode(response.body);
      }
    } else {
      return "Your provided pincode does not contain any vaccination center.";
    }
  }
}
