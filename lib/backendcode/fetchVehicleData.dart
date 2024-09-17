import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

Future<List<dynamic>> fetchVehicleData(String ID) async {
  try {
    final response = await http.get(
      Uri.parse('$getOneVehicleDataUrl/$ID'),
      headers: {'Content-Type': "application/json"},
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status']) {
        return List<dynamic>.from(responseData['vehicleInformation']);
      } else {
        print('Failed to fetch vehicle data: ${responseData['error']}');
        return [];
      }
    } else {
      throw Exception('Failed to fetch vehicle data');
    }
  } catch (error) {
    print("Error fetching vehicle data: $error");
    return [];
  }
}
