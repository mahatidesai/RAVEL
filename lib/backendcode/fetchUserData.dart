import 'dart:convert';
import 'package:carrental/config.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchUserData(String firebaseID) async {
  try {
    final response = await http.get(Uri.parse('$getOneUserDetailsUrl/$firebaseID'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status']) {
        return List<dynamic>.from(responseData['userData']);
      } else {
        print('Error fetching user data: ${responseData['error']}');
        return [];
      }
    } else {
      print("Failed to fetch the data, status code: ${response.statusCode}");
      return [];
    }
  } catch (error) {
    print("Error fetching user data: $error");
    return [];
  }
}
