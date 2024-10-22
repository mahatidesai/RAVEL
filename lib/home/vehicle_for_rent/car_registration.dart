import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carrental/screens/all.dart';
import 'package:http/http.dart' as http;

import '../../backendcode/registerVehicle.dart';


class car_registration extends StatefulWidget {


  final String initialCompanyName;
  final String initialVehicleName;
  final String initialDescription;
  final String initialRent;
  final String initialLocation;
  final String initialFuelType;
  final String initialVehicleType;
  final String initialSeaterValue;
  final String button;
  final String vehicleID;

  car_registration({
    required this.vehicleID,
    required this.initialCompanyName,
    required this.initialVehicleName,
    required this.initialDescription,
    required this.initialRent,
    required this.initialLocation,
    required this.initialFuelType,
    required this.initialVehicleType,
    required this.initialSeaterValue,
    required this.button,
  });

  @override
  State<car_registration> createState() => _car_registrationState();
}

class _car_registrationState extends State<car_registration> {

  TextEditingController vehicleCompanyName = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController vehicleDescription = TextEditingController();
  TextEditingController vehicleRent = TextEditingController();
  TextEditingController vehicleLocation = TextEditingController();
  TextEditingController fuelType = TextEditingController();


  static const List<String> vehicleSeater = <String>[" ",'5 Seater', '7 Seater', '9 Seater'];
  static const List<String> vehicleType = <String>['SCOOTER', 'CAR', 'BIKE', 'CYCLE'];
  static const List<String> fuel = <String>['PETROL', 'CNG', 'EV', 'DESIEL'];

  late List<String> imagesRef;
  late List<File> images;
  final pickImage = ImagePicker();
  String? vehicleValue;
  String? seaterValue;
  String? fuelValue;


  late String initialCompanyNameComp;
  late String initialVehicleNameComp;
  late String initialDescriptionComp;
  late String initialRentComp;
  late String initialLocationComp;
  late String initialFuelTypeComp;
  late String initialVehicleTypeComp;
  late String initialSeaterValueComp;



  @override
  void initState() {
    super.initState();
    images = [];
    imagesRef = [];

      vehicleCompanyName.text = widget.initialCompanyName.toUpperCase() ;
      vehicleName.text = widget.initialVehicleName.toUpperCase() ;
      vehicleDescription.text = widget.initialDescription.toUpperCase();
      vehicleRent.text = widget.initialRent.toUpperCase();
      vehicleLocation.text = widget.initialLocation.toUpperCase();
    vehicleValue = vehicleType.contains(widget.initialVehicleType)
        ? widget.initialVehicleType
        : vehicleType.first;

    seaterValue = vehicleSeater.contains(widget.initialSeaterValue)
        ? widget.initialSeaterValue
        : vehicleSeater.first;

    fuelValue = fuel.contains(widget.initialFuelType)
        ? widget.initialFuelType
        : fuel.first;

    // Store initial values for comparison later
    initialCompanyNameComp = widget.initialCompanyName.toUpperCase();
    initialVehicleNameComp = widget.initialVehicleName.toUpperCase();
    initialDescriptionComp = widget.initialDescription.toUpperCase();
    initialRentComp = widget.initialRent.toUpperCase();
    initialLocationComp = widget.initialLocation.toUpperCase();
    initialFuelTypeComp = widget.initialFuelType;
    initialVehicleTypeComp = widget.initialVehicleType;
    initialSeaterValueComp = widget.initialSeaterValue;

  }

  Map<String, dynamic> getUpdatedFields() {
    Map<String, dynamic> updatedFields = {};

    if (vehicleCompanyName.text != initialCompanyNameComp ) {
      updatedFields['vehilceCompanyName'] = vehicleCompanyName.text;
    }
    if (vehicleName.text != initialVehicleNameComp ) {
      updatedFields['vehicleName'] = vehicleName.text;
    }
    if (vehicleDescription.text != initialDescriptionComp) {
      updatedFields['vehicleDescription'] = vehicleDescription.text;
    }
    if (vehicleRent.text != initialRentComp) {
      updatedFields['vehicleRent'] = int.parse(vehicleRent.text);
    }
    if (vehicleLocation.text != initialLocationComp) {
      updatedFields['vehicleLocation'] = vehicleLocation.text;
    }
    if (widget.initialFuelType.isEmpty || !fuel.contains(widget.initialFuelType)) {
      fuelValue = fuel.first; // Ensure it defaults to a valid value
    } else {
      fuelValue = widget.initialFuelType;
    }
    if (widget.initialVehicleType.isEmpty || !vehicleType.contains(widget.initialVehicleType)) {
      vehicleValue = vehicleType.first; // Ensure it defaults to a valid value
    } else {
      vehicleValue = widget.initialVehicleType;
    }

    if (widget.initialSeaterValue.isEmpty || !vehicleSeater.contains(widget.initialSeaterValue)) {
      seaterValue = vehicleSeater.first; // Ensure it defaults to a valid value
    } else {
      seaterValue = widget.initialSeaterValue;
    }


    return updatedFields;
  }


  void uploadImage(ImageSource source) async {
    final firebaseStorage = FirebaseStorage.instance;

    if (await Permission.camera.request().isGranted || await Permission.photos.request().isGranted) {
      var pickedFile = await pickImage.pickImage(source: source);
      if (pickedFile != null) {
        var file = File(pickedFile.path);
        try {
          // Add a unique name for each file
          var fileName = DateTime.now().millisecondsSinceEpoch.toString();
          var snapshot = await firebaseStorage.ref().child('images/$fileName').putFile(file);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imagesRef.add(downloadUrl);
            images.add(file);
          });
        } catch (e) {
          print("Image upload failed: $e");
          showAlert(e.toString(), Colors.red);
        }
      } else {
        showAlert("No Image Received", Colors.black);
      }
    } else {
      showAlert("No permission", Colors.black);
    }
  }



  void showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick Image From"),
          insetPadding: EdgeInsets.symmetric(horizontal: 40),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  uploadImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera),
                title: Text("Camera"),
              ),
              ListTile(
                onTap: () {
                  uploadImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.image),
                title: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget displaySelectedImages() {
    return Container(
      height: 12.h,
      width: 90.w,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            height: 12.h,
            width: 40.w,
            color: Colors.white,
            margin: EdgeInsets.only(right: 2.w),
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  void showAlert(String result, Color displaycolor){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: InkWell(
          onTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> lend_vehicle_history()));
          },
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle),
              texts(result, 18.sp,displaycolor, FontWeight.normal),
            ],
          )),
        ),
      );
    }) ;
  }

  Future<void> updateVehicle(String vehicleID, Map<String, dynamic> updatedFields) async {

    var response = await http.put(Uri.parse('$updateVehicleUrl/$vehicleID'), 
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: texts("REGISTER  VEHICLE", 23.sp, Colors.white, FontWeight.normal),
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
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textfield("Vehicle Company Name", vehicleCompanyName),
                    SizedBox(height: 4.h),
                    textfield("Vehicle Name",vehicleName),
                    SizedBox(height: 4.h),
                    textfield("Vehicle Description", vehicleDescription),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: texts(
                        'Vehicle Type', 18.sp, Colors.white,FontWeight.normal),
                      ),
                    Container(
                      height: 6.h,
                      width: 90.w,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: DropdownButton<String>(
                          value: vehicleValue,
                          icon: const Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
                          onChanged: (String? value) {
                            setState(() {
                              vehicleValue = value!;
                            });
                          },
                          items: vehicleType.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: texts('Vehicle Images', 18.sp, Colors.white,FontWeight.normal),),
                    InkWell(
                      onTap: () {
                        showAlertBox();
                      },
                      child: Container(
                        height: 6.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: texts('ADD IMAGES', 16.sp, Colors.black,FontWeight.normal),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    images.isNotEmpty ? displaySelectedImages(): Container(),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: texts('Vehicle Seater', 18.sp, Colors.white,FontWeight.normal),
                    ),
                    Container(
                      height: 6.h,
                      width: 90.w,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: DropdownButton<String>(
                          value: seaterValue,
                          icon: const Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
                          onChanged: (String? value) {
                            setState(() {
                              seaterValue = value!;
                            });
                          },
                          items: vehicleSeater.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    textfield("Vehicle Rent",vehicleRent),
                    SizedBox(height: 4.h),
                    textfield("Vehicle Location", vehicleLocation),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: texts('Fuel Type', 18.sp, Colors.white,FontWeight.normal),
                    ),
                    Container(
                      height: 6.h,
                      width: 90.w,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: DropdownButton<String>(
                          value: fuelValue,
                          icon: const Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
                          onChanged: (String? value) {
                            setState(() {
                              fuelValue = value!;
                            });
                          },
                          items: fuel.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(child: buttons(widget.button, 22.sp, ()async{
                      if(widget.button=='REGISTER'){
                      var firebaseID = await FirebaseAuth.instance.currentUser?.uid;
                      var response = await registerVehicle(
                          firebaseID.toString(),
                          vehicleCompanyName.text.toString().toUpperCase(),
                          vehicleName.text.toString().toUpperCase(),
                          imagesRef,
                      vehicleDescription.text.toString().toUpperCase(),
                      vehicleValue.toString(),
                      seaterValue.toString(),
                      int.parse(vehicleRent.text),
                      vehicleLocation.text.toString().toUpperCase(),
                      fuelValue.toString());

                      if(response!=null)
                        {
                          showAlert("Registration Sucessfull", Colors.green);
                        }
                      else{
                        showAlert("Registration Unsucessful", Colors.red);

                      }
                    }else {
                        var updatedFields = await getUpdatedFields();

                        if (updatedFields.isNotEmpty) {
                          // Send only the changed fields to the backend
                          await updateVehicle(widget.vehicleID.toString(), updatedFields);
                        } else {
                          // No changes detected
                          showAlert("No fields were changed.", Colors.red);
                        }
                      }
                    }
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
