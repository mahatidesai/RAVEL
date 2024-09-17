import 'package:carrental/custom/drawable.dart';
import 'package:carrental/home/vehicle_for_rent/lend_vehicle_history.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';

class choice extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(foregroundColor: Colors.white, backgroundColor: Colors.transparent),
      drawer: drawable(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage('assets/images/backgroundcar.png'),
            fit: BoxFit.cover,
          ),

        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> vehicle_category()));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical:3.h),
                    child: Container(
                      height: MediaQuery.of(context).size.height/8.5,
                      width: MediaQuery.of(context).size.width/1.4,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(top: BorderSide(color: Color.fromRGBO(228, 221, 205, 1)), right: BorderSide(color: Color.fromRGBO(228, 221, 205, 1)), bottom: BorderSide(color: Color.fromRGBO(228, 221, 205, 1))),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50) )
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 9.w),
                            child: Column(
                              children: [
                                texts("RENT A",23.sp,Colors.white,FontWeight.normal),
                                texts("VEHICLE", 23.sp,Colors.white,FontWeight.normal)
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical:1.h, horizontal: 2.w),
                            child: Container(
                              height: 20.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(228, 221, 205, 1),
                                border: Border.all(color: Color.fromRGBO(228, 221, 205, 1)),
                                borderRadius:BorderRadius.circular(70)
                              ),
                              child: Icon(Icons.car_rental,size: 55,color: Colors.black)
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> lend_vehicle_history()));
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height/8.5,
                      width: MediaQuery.of(context).size.width/1.4,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(top:  BorderSide(color: Color.fromRGBO(228, 221, 205, 1)), left:  BorderSide(color: Color.fromRGBO(228, 221, 205, 1)), bottom:  BorderSide(color: Color.fromRGBO(228, 221, 205, 1))),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50) )
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical:1.h, horizontal: 2.w),
                            child: Container(
                              height: 20.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(228, 221, 205, 1),
                                  border: Border.all(color: Color.fromRGBO(228, 221, 205, 1)),
                                  borderRadius:BorderRadius.circular(70)
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.directions_car_filled_sharp,size:50,color: Colors.black,),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 7.w),
                            child: Column(
                              children: [
                                texts("LENT",23.sp,Colors.white,FontWeight.normal),
                                texts("A VEHICLE", 23.sp,Colors.white,FontWeight.normal)
                              ],
                            ),
                          ),
                        ],
                      )

                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}