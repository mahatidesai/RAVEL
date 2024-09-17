import 'dart:convert';

import 'package:carrental/config.dart';
import 'package:http/http.dart' as http;
Future<List<dynamic>> profileRent(renterFirebaseID) async{
  try{
    var response = await http.get(Uri.parse('$profileRentUrl/$renterFirebaseID'),
        headers: {'Content-Type': 'application/json'});
    if(response.statusCode == 200){
      final rentData = jsonDecode(response.body);
      if(rentData['status'])
        {
          return List<dynamic>.from(rentData['rentData']);
        }
      else{
        print("Error of status: ${rentData['error']}");
        return [];
      }
    }
    else{
      print("Response code not 200: ${response.statusCode}");
      return [];
    }
  }
  catch(error){
    print("Error: $error");
    return [];
  }
}