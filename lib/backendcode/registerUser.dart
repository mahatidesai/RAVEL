import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

Future<bool> registerUser(firebaseID, name, email, phoneNumber, LN) async{
  var userData = {
    "firebaseID": firebaseID,
    "name": name,
    "email": email,
    "phone": phoneNumber,
    "liscense": LN,
    "registrationDate": DateTime.now().toIso8601String(),
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