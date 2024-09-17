import 'package:carrental/custom/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carrental/screens/all.dart';

class category extends StatelessWidget{

  String? category_name;
  String? image_source;
  category(
      this.category_name,
      this.image_source,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Center(
            child: Container(
              height: 20.h,
              width: 85.w,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(228, 221, 205, 90),
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right:5.w,top:0.h),
                child: Image.asset(image_source!),
              ),
              Padding(
                padding: EdgeInsets.only(right:14.w, bottom: 5.h),
                child: texts(category_name!, 23.sp,Colors.white,FontWeight.normal),
              ),
  ])

        ]
    );
  }
}