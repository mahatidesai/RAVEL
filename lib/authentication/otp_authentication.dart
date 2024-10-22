import 'package:flutter/material.dart';
import '../screens/all.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carrental/config.dart';

class otp_authentication extends StatefulWidget {
  final String verificationid;
  final String phoneNumber;

  otp_authentication(this.verificationid, this.phoneNumber);

  @override
  State<otp_authentication> createState() => _otp_authenticationState();
}

class _otp_authenticationState extends State<otp_authentication> {
  var code = "";
  int? resendToken;

  Future<void> resendOTP() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + widget.phoneNumber,
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? token) {
          setState(() {
            resendToken = token;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Failed to resend OTP: $e");
    }
  }

  Future<List<dynamic>> fetchAllUsers() async {
    try {
      final response = await http.get(Uri.parse(getAllUsersUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          return List<dynamic>.from(responseData['users']);
        } else {
          print("Failed to fetch users: ${responseData['error']}");
          return [];
        }
      } else {
        print("Status Code not 200");
        return [];
      }
    } catch (error) {
      print("Error fetching users: $error");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 18.w,
      height: 6.h,
      textStyle: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white10
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: Colors.transparent
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              texts("VERIFICATION", 23.sp, Color.fromRGBO(4, 31, 52, 1), FontWeight.w400),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signinButtonBackground.png'),
            fit: BoxFit.cover,
          ),
          color: Color.fromRGBO(1, 1, 1, 1),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width / 1.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        onChanged: (value) {
                          code = value;
                        },
                      ),
                      SizedBox(height: 0.5.h),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: texts("Change Phone Number?", 12.sp, Colors.white, FontWeight.normal)
                          )
                      ),
                    ],
                  ),
                  buttons("SIGN IN", 23.sp, () async {
                    try {
                      PhoneAuthCredential credential = await PhoneAuthProvider
                          .credential(verificationId: widget.verificationid, smsCode: code);
                      var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                      // Fetch all users after successful sign-in
                      List<dynamic> users = await fetchAllUsers();
                      bool userExists = users.any((user) => user['phone'] == widget.phoneNumber);

                      if (userExists) {
                        // Navigate to choice page if user exists
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => choice()));
                      } else {
                        // Navigate to registration page if user does not exist
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => user_registration(widget.phoneNumber)));
                      }
                    } catch (ex) {
                      print("Error signing in: $ex");
                    }
                  }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      texts("Didn't get an OTP?", 11.sp, Colors.white, FontWeight.normal),
                      InkWell(
                          onTap: () {
                            resendOTP();
                          },
                          child: texts("Resend OTP", 12.sp, Colors.white, FontWeight.w100)
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
