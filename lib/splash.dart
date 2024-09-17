import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';


class splash extends StatefulWidget
{
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  void initState() {

    super.initState();
    Timer(const Duration(seconds: 4), () {
      if(FirebaseAuth.instance.currentUser==null)
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> sigin()));
      }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> choice()));
      }
    });
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color.fromRGBO(1,1,1,1),
          image: DecorationImage(
            image: AssetImage("assets/images/splash_screen.png"),
            fit: BoxFit.fitHeight
          )
        ),
      ),
    );
  }
}