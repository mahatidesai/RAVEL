import 'dart:convert';

import 'package:carrental/config.dart';
import 'package:http/http.dart' as http;

Future<bool> registerRentVehicle(renterFirebaseID, ownerFirebaseID, vehicleID, bookedDate, dateRentFrom, dateRentTo)async{
  try{
    var rentedData = {
      "renterFirebaseID": renterFirebaseID,
      "ownerFirebaseID": ownerFirebaseID,
      "vehicleID": vehicleID,
      "bookedDate": bookedDate,
      "dateRentFrom": dateRentFrom,
      "dateRentTo": dateRentTo
    };
    print(rentedData);
    var response = await http.post(Uri.parse(addRentInfoUrl),
    headers: {"Content-Type": "application/json"},
        body: jsonEncode(rentedData));
    if(response.statusCode == 200)
      {
          final dataRented = jsonDecode(response.body);
          if(dataRented['status']){
            return true;
          }
          else{
            print("Error:${dataRented['error']}");
            return false;
          }
      }
    else{
      print("Status code not 200");
      return false;
    }
  }
  catch(error){
    print("Error renting $error");
    return false;
  }
}