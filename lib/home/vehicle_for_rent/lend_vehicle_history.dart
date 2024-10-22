import 'package:carrental/backendcode/deleteVehicle.dart';
import 'package:carrental/backendcode/fetchLendVehicleHistory.dart';
import 'package:carrental/home/vehicle_for_rent/car_registration.dart';
import 'package:carrental/screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class lend_vehicle_history extends StatefulWidget {
  @override
  State<lend_vehicle_history> createState() => _lend_vehicle_historyState();
}

class _lend_vehicle_historyState extends State<lend_vehicle_history> {
  List<dynamic> lendInformation = [];
  bool isLoading = true; // Loading state
  bool noData = false;   // No data state

  @override
  void initState() {
    super.initState();
    _loadLendHistroy(FirebaseAuth.instance.currentUser!.uid);

    // Set a timeout to stop loading after 5 seconds if no data is found
    Future.delayed(Duration(seconds: 5), () {
      if (lendInformation.isEmpty) {
        setState(() {
          isLoading = false;
          noData = true;
        });
      }
    });
  }

  void _loadLendHistroy(firebaseID) async {
    final data = await fetch_lend_vehicle_history(firebaseID);
    if (data.isNotEmpty) {
      setState(() {
        lendInformation = data;
        isLoading = false; // Stop loading when data is fetched
      });
    } else {
      setState(() {
        isLoading = false; // Stop loading even if no data
        noData = true;     // Set no data state
      });
    }
  }

  void _deleteVehicleAndUpdateList(String vehicleID, int index) async {
    bool deleted = await deleteVehicle(vehicleID);
    if (deleted) {
      setState(() {
        lendInformation.removeAt(index); // Remove the vehicle from the list
      });
      _showAlertDialog("Vehicle Deleted Successfully", Colors.green);
    } else {
      _showAlertDialog("Vehicle Deletion Unsuccessful", Colors.red);
    }
  }

  void _showAlertDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: texts(message, 12.sp, color, FontWeight.normal),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: texts("LEND A VEHICLE", 23.sp, Colors.white, FontWeight.w500),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundimg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : noData
                  ? Center(
                child: texts("No Data Available", 16.sp, Colors.white,
                    FontWeight.normal),
              )
                  : ListView.builder(
                itemCount: lendInformation.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 3.h),
                  child: Container(
                    height: 18.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 40.h,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: Image.network(
                            lendInformation[index]['vehicleImage'][0],
                            width: 45.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2.w, bottom: 2.w),
                          child: Container(
                            width: 40.w,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                texts(
                                    lendInformation[index]
                                    ['vehicleName'],
                                    18.sp,
                                    Colors.black,
                                    FontWeight.normal),
                                SizedBox(
                                  height: 1.h,
                                ),
                                texts(
                                    "Rent: ${lendInformation[index]['vehicleRent'].toString()}/Day",
                                    16.sp,
                                    Colors.black,
                                    FontWeight.normal),
                                SizedBox(
                                  height: 1.2.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  car_registration(
                                                    vehicleID:
                                                    lendInformation[
                                                    index]
                                                    ['_id']
                                                        .toString(),
                                                    initialCompanyName:
                                                    lendInformation[
                                                    index][
                                                    'vehicleCompanyName'],
                                                    initialVehicleName:
                                                    lendInformation[
                                                    index][
                                                    'vehicleName'],
                                                    initialDescription:
                                                    lendInformation[
                                                    index][
                                                    'vehicleDescription'],
                                                    initialRent:
                                                    lendInformation[
                                                    index][
                                                    'vehicleRent'],
                                                    initialLocation:
                                                    lendInformation[
                                                    index][
                                                    'vehicleLocation'],
                                                    initialFuelType:
                                                    lendInformation[
                                                    index]
                                                    ['fuelType'],
                                                    initialVehicleType:
                                                    lendInformation[
                                                    index]
                                                    ['vehicleType'],
                                                    initialSeaterValue:
                                                    lendInformation[
                                                    index]
                                                    ['vehicleSeater'],
                                                    button: "UPDATE",
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit,
                                            size: 3.5.h)),
                                    IconButton(
                                        onPressed: () async {
                                          _deleteVehicleAndUpdateList(
                                              lendInformation[index]
                                              ['_id']
                                                  .toString(),
                                              index);
                                        },
                                        icon: Icon(Icons.delete,
                                            size: 3.5.h))
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => car_registration(
                vehicleID: '',
                initialCompanyName: '',
                initialVehicleName: '',
                initialDescription: '',
                initialRent: '',
                initialLocation: '',
                initialFuelType: '',
                initialVehicleType: '',
                initialSeaterValue: '',
                button: "REGISTER",
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 4.h,
        ),
      ),
    );
  }
}
