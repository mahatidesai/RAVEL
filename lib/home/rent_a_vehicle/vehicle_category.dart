import 'package:carrental/home/rent_a_vehicle/seater.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';


class vehicle_category extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            image: AssetImage("assets/images/backgroundimg.png"),
            fit: BoxFit.cover
          )
        ),
          child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 11.h),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> vehicle_information("SCOOTER", " ")));
                          },
                            child: category("SCOOTER", "assets/images/category_images/scooter.png")),
                        SizedBox(height: 1.h),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> seater()));
                          },
                            child: category("CAR", "assets/images/category_images/car.png")),
                        SizedBox(height: 3.h),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> vehicle_information("BIKE", " ")));
                          },
                            child: category("BIKE", "assets/images/category_images/bike.png")),
                        SizedBox(height: 3.h),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> vehicle_information("CYCLE", " ")));
                          },
                            child: category("CYCLE", "assets/images/category_images/cycle.png"))
                    ]
                    ),
                ),
                            ),
              ),
          ),
        )


        );
  }
}