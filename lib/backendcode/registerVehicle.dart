import 'dart:convert';
import 'package:carrental/screens/all.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

Future<http.Response> registerVehicle(firebaseID, vehicleCompanyName, vehicleName, imagesRef, vehicleDescription,vehicleValue, seaterValue, vehicleRent, vehicleLocation, fuelType)
async{
    var vehicleData = {
      'firebaseID': firebaseID,
      'vehicleCompanyName': vehicleCompanyName,
      'vehicleName': vehicleName,
      'vehicleImage': imagesRef,
      'vehicleDescription': vehicleDescription,
      'vehicleType': vehicleValue,
      'vehicleSeater': seaterValue,
      'vehicleRent': vehicleRent,
      'vehicleLocation': vehicleLocation,
      'fuelType': fuelType,
    };


    var response = await http.post(Uri.parse(vehicleRegistrationUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(vehicleData));

    return response;
}

