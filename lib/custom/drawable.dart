import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/all.dart';

class drawable extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor:Color.fromRGBO(5, 18, 29, 70),
        elevation: 2,
        width: 50.w,
        child: Padding(
            padding: EdgeInsets.only(top: 14.h),
            child:Column(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> profile()));
                },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 2.w, right:1.w),
                          child: Icon(Icons.account_circle_sharp, size: 40,color: Color.fromRGBO(228, 221, 205, 1),),
                        ),
                        Text("Profile", style: TextStyle(
                          fontSize:28,
                          color: Color.fromRGBO(228, 221, 205, 1),
                        ),),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                  ),),
                ElevatedButton(onPressed: (){
                  FirebaseAuth.instance.signOut();
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: texts("Logged Out Sucessfully", 18.sp, Colors.green, FontWeight.normal),

                          ),
                        ),
                      );
                    }) ;

                  //signinout the user from the application.
                },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical:2.h),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 2.w, right:1.w),
                          child: Icon(Icons.logout_rounded, size: 40,color:Color.fromRGBO(228, 221, 205, 1),),
                        ),
                        Text("Log out", style: TextStyle(
                          fontSize:25,
                          color: Color.fromRGBO(228, 221, 205, 1),
                        ),),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                  ),),
                ElevatedButton(onPressed: (){
                  if(FirebaseAuth.instance.currentUser==null){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) => sigin()), (Route route) => false);}
                  else{
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: texts("You are logged in!", 18.sp, Colors.red, FontWeight.normal),

                          ),
                        ),
                      );
                    }) ;
                  }
                },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 1.w, right:1.w),
                          child: Icon(Icons.login, size: 40,color:Color.fromRGBO(228, 221, 205, 1),),
                        ),
                        Text("Log In", style: TextStyle(
                          fontSize:25,
                          color: Color.fromRGBO(228, 221, 205, 1),
                        ),),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                  ),)
              ],
            ))
    );

  }
}