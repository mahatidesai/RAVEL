import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';


Future<List<dynamic>> fetch_lend_vehicle_history(firebaseID) async{
  try{
    var response = await http.get(Uri.parse('$getlendVehicleHistoryUrl/$firebaseID'));
    if(response.statusCode==200)
      {
        final responseData = jsonDecode(response.body);
        if(responseData['status']){
          return List<dynamic>.from(responseData['lendHistory']);
        }
        else{
          print("Failed to fetch lend history: ${responseData['error']}");
          return [];
        }
      }else{
      print("Status Code not 200");
      return [];
    }
  }
  catch(error){
    print("Error fetching lend vehicle history: $error");
    return [];
  }

}