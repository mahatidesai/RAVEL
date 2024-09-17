import 'package:carrental/screens/all.dart';
import 'package:flutter/material.dart';

class vehicles extends StatelessWidget{

  String name;
  String image;
  String rent;
  String ID;
  vehicles(
      this.name,
      this.image,
      this.rent,
      this.ID
      );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> more_info(ID)));
      },
      child: Card(
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))
        ),
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        color: Color.fromRGBO(35, 50, 71, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            texts(name, 16.sp, Colors.white,FontWeight.w400),
            Image.network(image,height: 18.h,width:120.w),
            Padding(
              padding: EdgeInsets.only(left:1.h),
              child: texts("RENT: $rent/day", 15.sp,Colors.white,FontWeight.normal),
            ),
            ]    ),
      ),
    );

  }
}