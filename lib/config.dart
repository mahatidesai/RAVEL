// final url = "http://10.100.36.234:5000/"; //College Url
final url = "http://192.168.0.123:5000/"; //Home Wifi
// final url = "http://192.168.112.70:5000/"; //Mahati Hotspot

final userRegistrationUrl = url + "user_registration"; //register user

final vehicleRegistrationUrl  = url + 'vehicle_registration'; //register vehicle

final getAllVehicleUrl = url + 'all_vehicle_data'; //get vehicle by vehicleType and vehicleSeater

final getOneVehicleDataUrl = url + 'get_one_vehicle_data'; //get vehicle by the vehicle ID

final getOneUserDetailsUrl = url + 'get_one_user_details'; //get user details by the firebase ID

final getlendVehicleHistoryUrl = url + 'get_lend_vehicle_history'; //get vehicle by FirebaseID

final deleteVehicleUrl = url + 'delete_vehicle'; //delete vehicle by the ID

final addRentInfoUrl = url + 'rented'; // registering the rent details

final profileRentUrl = url + 'rented_vehicles_by_single_user'; //getting the rented vehicle by a particular user by the firebaseID

final updateVehicleUrl = url + 'update_vehicle'; //updating vehicle data

final updateUserUrl = url+ 'update_user'; //updating user data

final getAllUsersUrl = url + 'get_all_user_data'; //getting all the users
