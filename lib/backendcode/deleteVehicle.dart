import 'dart:convert';

import 'package:carrental/config.dart';
import 'package:http/http.dart' as http;

Future<bool> deleteVehicle(vehicleID) async{
  try{
    print('$deleteVehicleUrl/$vehicleID');
    var response = await http.post(Uri.parse('$deleteVehicleUrl/$vehicleID'));
    if(response.statusCode==200){
      final responseData = jsonDecode(response.body);
      if(responseData['status']){
        return true;
      }
      else{
        print("vehicle Not deleted: ${responseData['error']}");
        return false;
      }
    }
    else{
      print("Failed to delete vehicle");
      return false;
    }
  }
  catch(error){
    print("Error deleteing the vehicle:$error");
    return false;
  }
}