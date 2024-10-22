import 'dart:convert';

import 'package:carrental/backendcode/fetchLendVehicleHistory.dart';
import 'package:carrental/backendcode/fetchUserData.dart';
import 'package:carrental/backendcode/fetchVehicleData.dart';
import 'package:carrental/screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import '../backendcode/profileRent.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController liscense = TextEditingController();
  TextEditingController phone = TextEditingController();
  bool enableName = false;
  bool enableEmail = false;
  bool enableLiscense = false;

  late String initialName;
  late String initialEmail;
  late String initialLiscense;

  void showAlert(String result, Color displaycolor) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: texts(result, 18.sp, displaycolor, FontWeight.normal),
              ),
            ),
          );
        });
  }

  List<dynamic> userDetails = [];
  List<dynamic> lendData = [];
  List<dynamic> rentData = [];
  List<dynamic> rentedVehicleData = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadlendData();
    _loadRentData();
  }

  Future<void> _loadUserData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var firebaseID = FirebaseAuth.instance.currentUser!.uid.toString();
      final userData = await fetchUserData(firebaseID);
      if (userData.isNotEmpty) {
        setState(() {
          userDetails = userData;
          name.text = userDetails[0]['name'];
          email.text = userDetails[0]['email'];
          liscense.text = userDetails[0]['liscense'];
          phone.text = userDetails[0]['phone'];
          initialName = userDetails[0]['name'];
          initialEmail=userDetails[0]['email'];
          initialLiscense = userDetails[0]['liscense'];
        });
      } else {
        print("No user Data found!");
      }
    } else {
      showAlert("Please Login", Colors.red);
    }
  }

  Future<void> _loadlendData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var firebaseID = FirebaseAuth.instance.currentUser!.uid.toString();
      final lendVehicle = await fetch_lend_vehicle_history(firebaseID);
      if (lendVehicle.isNotEmpty) {
        setState(() {
          lendData = lendVehicle;
        });
        print(lendData);
      } else {
        print("No Lend Data");
      }
    } else {
      showAlert("Please Login", Colors.red);
    }
  }

  Future<void> _loadRentData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var renterfirebaseID = FirebaseAuth.instance.currentUser!.uid.toString();
      final rentingData = await profileRent(renterfirebaseID);
      if (rentingData.isNotEmpty) {
        setState(() {
          rentData = rentingData;
        });
        await _loadRentedVehicleData();
      }
    } else {
      showAlert("Please Login", Colors.red);
    }
  }

  Future<void> _loadRentedVehicleData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (rentData.isEmpty) {
        print("No rentData available to load vehicles");
        return;
      }
      for (int i = 0; i < rentData.length; i++) {
        var vehicle_id = rentData[i]['vehicleID'];
        var rentedData = await fetchVehicleData(vehicle_id);
        setState(() {
          rentedVehicleData.add(rentedData);
        });
        print(rentedVehicleData);
      }
    } else {
      showAlert("Please Login", Colors.red);
    }
  }

  Map<String, dynamic> getUpdatedFields() {
    Map<String, dynamic> updatedFields = {};

    if(name.text != initialName){
      updatedFields['name']=name.text;
    }
    if(email.text != initialEmail){
      updatedFields['name']=email.text;
    }
    if(liscense.text != initialLiscense){
      updatedFields['name']=liscense.text;
    }
    return updatedFields;
  }

  Future<void> updateUser(Map<String, dynamic> updatedFields) async {

    print('$updateUserUrl/${userDetails[0]['_id']}');
    var response = await http.put(Uri.parse('$updateUserUrl/${userDetails[0]['_id']}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        ...updatedFields,  // Include only updated fields in the body
      }),
    );


    if (response.statusCode == 200) {
      // Handle success
      showAlert("Update Successful", Colors.green);
    } else {
      // Handle error
      showAlert("Update Failed", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: texts("PROFILE", 20.sp, Colors.white, FontWeight.w400),
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
                fit: BoxFit.fitHeight,
              ),
            ),
            child: SafeArea(
              child: userDetails.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          height: 20.h,
                          width: 100.w,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 18.h,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: 100.w,
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    texts("Name:", 18.sp, Colors.white,
                                        FontWeight.normal),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:name,
                                          enabled: enableName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17.sp,
                                          ),
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                                          ),
                                          onChanged: (value)=> getUpdatedFields(),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 2.w),
                                        child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                enableName = !enableName;
                                              });
                                            },
                                            child: Icon(Icons.edit, color: Colors.white, size: 18.sp)),
                                      )
                                    ],
                                  ),
                                    SizedBox(height: 4.h,),
                                    texts("Email ID:", 18.sp, Colors.white,
                                        FontWeight.normal),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:email,
                                            enabled: enableEmail,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.sp,
                                            ),
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                                            ),
                                            onChanged: (value)=> getUpdatedFields(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 2.w),
                                          child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  enableEmail = !enableEmail;
                                                });
                                              },
                                              child: Icon(Icons.edit, color: Colors.white, size: 18.sp)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4.h,),
                                    texts("Phone Number:", 18.sp, Colors.white,
                                        FontWeight.normal),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: phone,
                                            enabled: false,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.sp,
                                            ),
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 2.w)
                                    ),
                                    ]),
                                    SizedBox(height: 4.h,),
                                    texts("Liscense Number:", 18.sp, Colors.white,
                                        FontWeight.normal),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:liscense,
                                            enabled: enableLiscense,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.sp,
                                            ),
                                            cursorColor: Colors.white,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                                            ),
                                            onChanged: (value)=> getUpdatedFields(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 2.w),
                                          child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  enableLiscense = !enableLiscense;
                                                });
                                              },
                                              child: Icon(Icons.edit, color: Colors.white, size: 18.sp)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4.h,),
                                    buttons("UPDATE", 14.sp, ()async {
                                      var updatedFields = await getUpdatedFields();

                                      if (updatedFields.isNotEmpty) {
                                        // Send only the changed fields to the backend
                                        await updateUser( updatedFields);
                                      } else {
                                        // No changes detected
                                        showAlert("No fields were changed.", Colors.red);
                                      }
                                    }),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    texts("Rented Vehicles: ", 18.sp,
                                        Colors.white, FontWeight.normal),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    rentData.isNotEmpty &&
                                            rentedVehicleData.isNotEmpty
                                        ? SizedBox(
                                            height: 14.2.h,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  height: 14.2.h,
                                                  width: 45.w,
                                                  color: Colors.white,
                                                  margin: EdgeInsets.only(
                                                      right: 2.w),
                                                  child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.network(
                                                          rentedVehicleData[
                                                                  index][0][
                                                              'vehicleImage'][0],
                                                          height: 14.2.h,
                                                          width: 45.w,
                                                          fit: BoxFit.fill,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                        Container(
                                                            height: 14.2.h,
                                                            width: 45.w,
                                                            color:
                                                                Color.fromRGBO(
                                                                    5,
                                                                    18,
                                                                    29,
                                                                    170)),
                                                        texts(
                                                            rentedVehicleData[
                                                                    index][0]
                                                                ['vehicleName'],
                                                            18.sp,
                                                            Colors.white,
                                                            FontWeight.normal),
                                                      ]),
                                                );
                                              },
                                              itemCount:
                                                  rentedVehicleData.length,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                          )
                                        : texts(
                                            "No vehicle rented by you!",
                                            14.sp,
                                            Colors.white,
                                            FontWeight.normal),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    texts("Lent Vehicles: ", 18.sp,
                                        Colors.white, FontWeight.normal),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                      lendData.isNotEmpty?
                                      SizedBox(
                                        height: 14.2.h,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 14.2.h,
                                              width: 45.w,
                                              color: Colors.white,
                                              margin:
                                                  EdgeInsets.only(right: 2.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.network(
                                                          lendData[index][
                                                              'vehicleImage'][0],
                                                          height: 14.2.h,
                                                          width: 45.w,
                                                          fit: BoxFit.fill,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                        Container(
                                                            height: 14.2.h,
                                                            width: 45.w,
                                                            color:
                                                                Color.fromRGBO(
                                                                    5,
                                                                    18,
                                                                    29,
                                                                    170)),
                                                        texts(
                                                            lendData[index]
                                                                ['vehicleName'],
                                                            18.sp,
                                                            Colors.white,
                                                            FontWeight.normal),
                                                      ]),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: lendData.length,
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ):
                                      texts("No vehicle lent by you!", 14.sp,
                                          Colors.white, FontWeight.normal),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          ),

                      ),
              ]
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
            )));
  }
}
