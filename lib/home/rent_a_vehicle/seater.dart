import 'package:carrental/screens/all.dart';
import 'package:flutter/material.dart';

class seater extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: texts("RENT A VEHICLE", 22.sp, Colors.white,FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
    ),
    body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/seater_background.png"),
        fit: BoxFit.cover
        )
        ),
      child:SafeArea(
          child:
          Align(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
                  child: Column(
                    children: [
                      texts("5 SEATER", 26.sp, Colors.white, FontWeight.normal),
                      Container(
                        alignment: Alignment.center,
                        height: 70.h,
                        width: 90.w,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => vehicle_information("CAR","5 Seater")));
                          },
                            child: Image.asset('assets/images/5seater.png', fit: BoxFit.fitWidth,)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
                  child: Column(
                    children: [
                      texts("7 SEATER", 26.sp, Colors.white, FontWeight.normal),
                      Container(
                        alignment: Alignment.center,
                        height: 70.h,
                        width: 90.w,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => vehicle_information("CAR","7 Seater")));
                          },
                            child: Image.asset('assets/images/7seater.png', fit: BoxFit.fitHeight,)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 5.w),
                  child: Column(
                    children: [
                      texts("9 SEATER", 26.sp, Colors.white, FontWeight.normal),
                      Container(
                        alignment: Alignment.center,
                        height: 70.h,
                        width: 90.w,
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){

                          },
                            child: Image.asset('assets/images/9seater.png', fit: BoxFit.fitWidth,)),
                      ),
                    ],
                  ),
                ),

              ]),
          )),
          ),




    );

  }
}