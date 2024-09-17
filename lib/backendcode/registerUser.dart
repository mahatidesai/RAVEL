import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

registerUser(firebaseID, name, email, phoneNumber, LN) async{
  var userData = {
    "firebaseID": firebaseID,
    "name": name,
    "email": email,
    "phone": phoneNumber,
    "liscense": LN,
  };

  var response = await http.post(Uri.parse(userRegistrationUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData));
  if (response!=null){
    return true;
  }
  else{
    return false;
  }
}