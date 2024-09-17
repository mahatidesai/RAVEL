import 'package:carrental/backendcode/fetchLendVehicleHistory.dart';
import 'package:carrental/backendcode/fetchUserData.dart';
import 'package:carrental/backendcode/fetchVehicleData.dart';
import 'package:carrental/screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../backendcode/profileRent.dart';

class profile extends StatefulWidget{
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {


  void showAlert(String result, Color displaycolor){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Center(
            child: texts(result, 18.sp,displaycolor, FontWeight.normal),

          ),
        ),
      );
    }) ;
  }

  List<dynamic> userDetails = [];
  List<dynamic> lendData = [];
  List<dynamic> rentData =[];
  List<dynamic> rentedVehicleData=[];
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadlendData();
    _loadRentData();
  }

  Future<void> _loadUserData()async {
    if (FirebaseAuth.instance.currentUser != null) {
      var firebaseID = FirebaseAuth.instance.currentUser!.uid.toString();
      final userData = await fetchUserData(firebaseID);
        if (userData.isNotEmpty) {
          setState(() {
            userDetails = userData;
          });
        }
        else {
          print("No user Data found!");
        }
      }
    else {
      showAlert("Please Login", Colors.red);
    }
  }

  Future<void> _loadlendData() async{
    if(FirebaseAuth.instance.currentUser!=null){
      var firebaseID = FirebaseAuth.instance.currentUser!.uid.toString();
      final lendVehicle = await fetch_lend_vehicle_history(firebaseID);
      if(lendVehicle.isNotEmpty){
        setState(() {
          lendData = lendVehicle;
        });
        print(lendData);
      }
      else{
        print("No Lend Data");
      }
    }
    else{
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
      for(int i=0; i<rentData.length;i++)
        {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title:texts("PROFILE", 20.sp, Colors.white,FontWeight.w400),
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
              child: userDetails.isNotEmpty?Column(
                children: [
                   Container(
                    height:20.h,
                     width:100.w,
                   child: CircleAvatar(child: Icon(Icons.account_circle_outlined, size: 18.h,color: Colors.white,),
                   backgroundColor: Colors.transparent,),
                   ),
                  SizedBox(height: 5.h,),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width:100.w,
                        color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            texts("Name:", 18.sp, Colors.white,FontWeight.normal),
                            TextFormField(
                              initialValue:userDetails[0]['name'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
                              ),
                            ),
                            SizedBox(height: 5.2.h,),
                            texts("Email:", 18.sp, Colors.white,FontWeight.normal),
                            TextFormField(
                              initialValue:userDetails[0]['email'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
                              ),
                            ),
                            SizedBox(height: 5.2.h,),
                            texts("Phone Number:", 18.sp, Colors.white,FontWeight.normal),
                            TextFormField(
                              initialValue:userDetails[0]['phone'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
                              ),
                            ),
                            SizedBox(height: 5.2.h,),
                            texts("Liscense Number:", 18.sp, Colors.white,FontWeight.normal),
                            TextFormField(
                              initialValue:userDetails[0]['liscense'].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.edit, color: Colors.white, size: 20.sp),
                              ),
                            ),
                            SizedBox(height: 6.h,),
                            texts("Rented Vehicles: ", 18.sp, Colors.white, FontWeight.normal),
                           rentData.isNotEmpty && rentedVehicleData.isNotEmpty ?SizedBox(
                             height: 14.2.h,
                             child: ListView.builder(
                                 itemBuilder: (context, index){
                               return Container(
                               height: 14.2.h,
                               width: 45.w,
                               color: Colors.white,
                                 margin: EdgeInsets.only(right:2.w),
                                 child: Stack(
                                   alignment: Alignment.center,
                                     children: [
                                       Image.network(rentedVehicleData[index][0]['vehicleImage'][0], height: 14.2.h,width:45.w,fit: BoxFit.fill, alignment: Alignment.center,),
                                       Container(height: 14.2.h, width: 45.w,color: Color.fromRGBO(5,18,29, 170)),
                                       texts(rentedVehicleData[index][0]['vehicleName'], 18.sp, Colors.white, FontWeight.normal),

                                     ]),
                             );},
                               itemCount: rentedVehicleData.length,
                               scrollDirection: Axis.horizontal,
                             ),
                           ): texts("No vehicle rented by you!", 14.sp, Colors.white, FontWeight.normal),
                            SizedBox(height: 6.h,),
                            texts("Lent Vehicles: ", 18.sp, Colors.white, FontWeight.normal),
                            if (lendData.isNotEmpty) SizedBox(
                              height: 14.2.h,
                              child: ListView.builder(
                                itemBuilder: (context, index){
                                  return Container(
                                    height:  14.2.h,
                                    width: 45.w,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(right:2.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                            children: [
                                              Image.network(lendData[index]['vehicleImage'][0],height: 14.2.h,width:45.w,fit: BoxFit.fill,alignment: Alignment.center,),
                                              Container(height: 14.2.h, width: 45.w,color: Color.fromRGBO(5,18,29, 170)),
                                              texts(lendData[index]['vehicleName'], 18.sp, Colors.white, FontWeight.normal),
                                  ]),
                                      ],
                                    ),
                                  );},
                                itemCount: lendData.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ) else texts("No vehicle lent by you!", 14.sp, Colors.white, FontWeight.normal),
                            SizedBox(height: 6.h,),
                          ],
                        ),

                      ),),
                    ),
                  ),
                ],
              ):Center(child: CircularProgressIndicator(color: Colors.white,)),
            )
    )
    );
  }
}