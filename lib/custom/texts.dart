import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class texts extends StatelessWidget{

  String button_text;
  double font_size;
  Color color;
  FontWeight fontWeight;
  texts(
      this.button_text,
      this.font_size,
      this.color,
      this.fontWeight,
      );
  @override
  Widget build(BuildContext context) {
    return Text(
      button_text,
      style: TextStyle(
        color: color,
        fontSize: font_size,
        fontFamily: "Alata",
        fontWeight: fontWeight,
      ),
    );

  }
}