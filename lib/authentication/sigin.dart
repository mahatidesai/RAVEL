import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sigin extends StatefulWidget {
  @override
  State<sigin> createState() => _siginState();
}

class _siginState extends State<sigin> {
  String validPhoneno = "";
  phoneValidation(phonenoController) {
    RegExp regExp = RegExp(r'^[0-9]{10}$');
    if (regExp.hasMatch(phonenoController)) {
      setState(() {
        validPhoneno = "";
      });
    } else {
      setState(() {
        validPhoneno = "Please Enter Valid Phone Number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var phonenoController = TextEditingController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: texts(
              "SIGNIN", 24.sp, Color.fromRGBO(4, 31, 52, 1), FontWeight.w500),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signinButtonBackground.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                    child: texts(
                        "Phone No: ", 20.sp, Colors.white, FontWeight.normal),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: TextFormField(
                      controller: phonenoController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontFamily: "Alata", fontSize: 13.sp),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: " | Enter Phone Number",
                        prefix: texts(
                            "+91", 13.sp, Colors.black, FontWeight.normal),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  if (validPhoneno.isNotEmpty)
                    Align(
                      alignment: Alignment.center,
                      child: texts(validPhoneno, 10.sp, Colors.yellow,
                          FontWeight.normal),
                    ),
                  SizedBox(height: 6.h),
                  Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height / 15,
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: buttons("SEND OTP", 22.sp, () async {
                          phoneValidation(phonenoController.text);
                          if (validPhoneno.isEmpty) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '+91' + phonenoController!.text.trim(),
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException ex) {},
                                codeSent:
                                    (String verificationid, int? resendtoken) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              otp_authentication(
                                                  verificationid,
                                                  phonenoController.text
                                                      .toString())));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationid) {});
                          } else {}
                        })),
                  ),
                ]),
          ),
        ),
        // ),
      ),
    );
  }
}
