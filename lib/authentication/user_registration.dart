import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';


import '../backendcode/registerUser.dart';

class user_registration extends StatefulWidget {
  final String  phoneNumber;
  user_registration(
      this.phoneNumber,
      );
  @override
  State<user_registration> createState() => _user_registrationState();
}

class _user_registrationState extends State<user_registration> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController LN = TextEditingController();

  String nameVal="";
  String emailVal="";
  String liscense="";

  nameValidation(name){
    if(name.toString().isNotEmpty){
      nameVal="";
      return true;
    }
    else{
      setState(() {
        nameVal="This field cannot be empty";
      });
      return false;
    }
  }

  emailValidation(email){
    RegExp regExp = RegExp(r'^[A-Za-z.]+@[a-zA-Z]+.[a-zA-Z]{2,}$');
    if(email.toString().isNotEmpty){
      if(regExp.hasMatch(email)){
        emailVal="";
        return true;
      }
      else{
        setState(() {
          emailVal = "Incorrect Email Format";
        });
        return false;
      }
    }
    else{
      emailVal = "This field cannot be empty";
      return false;
    }
  }

  licenseValidation(LN) {
    print(LN.toString());
    RegExp regExp = RegExp(r'^[A-Z]{2}[0-9]{13}$');
    if (LN.toString().isNotEmpty) {
      if (LN.toString().trim().length == 15) {
        if (regExp.hasMatch(LN)) {
          setState(() {
            liscense = "";
          });
          return true;
        } else {
          setState(() {
            liscense = "Incorrect License Format";
          });
          return false;
        }
      } else {
        setState(() {
          liscense = "License Number should have 15 characters";
        });
        return false;
      }
    } else {
      setState(() {
        liscense = "This field cannot be empty";
      });
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical:10.h),
            child: texts("REGISTRATION", 23.sp,Colors.white,FontWeight.w500),
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
              )
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical:5.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: texts("Name: ", 18.sp,Colors.white,FontWeight.normal),
                          ),
                          TextField(
                            controller: name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: "Alata",
                              fontWeight: FontWeight.normal,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.zero
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onChanged: (value){
                              nameValidation(name.text);
                            },
                          ),
                          texts(nameVal, 10.sp, Colors.yellow, FontWeight.normal),
                          SizedBox(height: 2.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: 1.h),
                            child: texts("Email: ", 18.sp,Colors.white,FontWeight.normal),
                          ),
                          TextField(
                              controller: email,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: "Alata",
                                fontWeight: FontWeight.normal,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            onChanged: (value){
                                emailValidation(email.text);
                            },
                          ),
                          texts(emailVal, 10.sp, Colors.yellow, FontWeight.normal),
                          SizedBox(height: 2.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: 1.h),
                            child: texts("Phone No: ", 18.sp,Colors.white,FontWeight.normal),
                          ),
                          TextFormField(
                            initialValue: widget.phoneNumber,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: "Alata",
                                fontWeight: FontWeight.normal,
                              ),
                              enabled: false,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),),
                          SizedBox(height: 2.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: 1.h),
                            child: texts("LicenseNumber: ", 18.sp,Colors.white,FontWeight.normal),
                          ),
                          TextField(
                            controller: LN,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily: "Alata",
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.zero
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                          onChanged: (value){
                              licenseValidation(LN.text);
                          },),
                          texts(liscense, 10.sp, Colors.yellow, FontWeight.normal),
                          SizedBox(height: 5.h),
                          Center(
                            child: Container(
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: buttons("DONE", 18.sp, () async {
                                  if (nameValidation(name.text)==true && emailValidation(email.text)==true && licenseValidation(LN.text)==true) {
                                    var firebaseID = await FirebaseAuth.instance.currentUser?.uid;
                                    registerUser(firebaseID.toString(), name.text.toString(), email.text.toString(), widget.phoneNumber.toString(), LN.text.toString());
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (context) => choice()));
                                  }
                                }
                                )),
                          ),
                        ],
                      )),
                ),
              ),
            ))
    );
  }
}
