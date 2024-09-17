import 'package:carrental/screens/all.dart';
import 'package:flutter/material.dart';

class textfield extends StatelessWidget{

  String fieldName;
  TextEditingController textEditingController;
  String initialValue;
  textfield(
      this.fieldName,
      this.textEditingController,
      this.initialValue
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: texts(
              fieldName, 18.sp, Colors.white, FontWeight.normal),
        ),
        TextFormField(
          controller: textEditingController,
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
                borderRadius: BorderRadius.zero),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ],
    );
  }
}