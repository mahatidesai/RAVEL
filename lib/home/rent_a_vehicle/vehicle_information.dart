import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';
import 'package:http/http.dart' as http;

class vehicle_information extends StatefulWidget {
  final String vehicleType;
  final String vehicleSeater;

  vehicle_information(this.vehicleType, this.vehicleSeater);

  @override
  State<vehicle_information> createState() => _vehicle_informationState();
}

class _vehicle_informationState extends State<vehicle_information> {
  List<dynamic> vehicleData = [];
  List<dynamic> filteredVehicleData = [];
  TextEditingController searchController = TextEditingController();

  String result = "";
  bool isLoading = true; // Loading state
  bool noData = false;   // No data state

  @override
  void initState() {
    super.initState();
    fetchVehicles(widget.vehicleType, widget.vehicleSeater);

    // Set a timeout to stop loading after 5 seconds if no data is found
    Future.delayed(Duration(seconds: 5), () {
      if (vehicleData.isEmpty) {
        setState(() {
          isLoading = false;
          noData = true;
        });
      }
    });
  }

  Future<void> fetchVehicles(String vehicleType, String vehicleSeater) async {
    try {
      final response = await http.get(
        Uri.parse(getAllVehicleUrl + '\\' + vehicleType + '\\' + vehicleSeater),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status']) {
          setState(() {
            vehicleData = responseData['vehicles'];
            filteredVehicleData = vehicleData;
            isLoading = false; // Stop loading when data is fetched
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading
            noData = true;     // Set no data state
          });
          print('Failed to fetch vehicles: ${responseData['error']}');
        }
      } else {
        throw Exception('Failed to fetch vehicles');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        noData = true;
      });
      print('Error: $error');
      // Handle errors appropriately, e.g., show an error message to the user
    }
  }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      // Reset filtered list to show all vehicles if query is empty
      setState(() {
        filteredVehicleData = vehicleData;
        result = ""; // Reset the result message
      });
    } else {
      // Filter vehicles based on name, company, or location
      List<dynamic> filteredList = vehicleData.where((vehicle) {
        String vehicleName = vehicle['vehicleName'].toLowerCase();
        String vehicleCompany = vehicle['vehicleCompanyName'].toLowerCase();
        String vehicleLocation =
        vehicle['vehicleLocation'].toLowerCase(); // Assuming 'vehicleLocation' field is available

        return vehicleName.contains(query.toLowerCase()) ||
            vehicleCompany.contains(query.toLowerCase()) ||
            vehicleLocation.contains(query.toLowerCase());
      }).toList();

      if (filteredList.isNotEmpty) {
        setState(() {
          filteredVehicleData = filteredList;
          result = ""; // Reset the result message
        });
      } else {
        setState(() {
          result =
          "\t\t\t\t\t\t\t\t\t\t\t\t\t\tNo data found! \nYou may browse the following.";
          filteredVehicleData = vehicleData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: texts(widget.vehicleType, 20.sp, Colors.white, FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundimg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(1.h),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    filterVehicles(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search vehicles (Name, Company, Location)',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              texts(result, 12.sp, Colors.white, FontWeight.normal),
              Expanded(
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : noData
                    ? Center(
                  child: texts("No Data Available", 16.sp,
                      Colors.white, FontWeight.normal),
                )
                    : filteredVehicleData.isNotEmpty
                    ? GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.h,
                    childAspectRatio: 0.69,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: filteredVehicleData.length,
                  itemBuilder: (context, index) {
                    return vehicles(
                      (filteredVehicleData[index]
                      ['vehicleCompanyName'] +
                          ' ' +
                          filteredVehicleData[index]
                          ['vehicleName'])
                          .toString(),
                      filteredVehicleData[index]['vehicleImage']
                      [0],
                      filteredVehicleData[index]['vehicleRent']
                          .toString(),
                      filteredVehicleData[index]['_id']
                          .toString(),
                    );
                  },
                )
                    : Center(
                  child: texts(
                      "No matching vehicles found", 16.sp,
                      Colors.white, FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
