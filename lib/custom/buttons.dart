import 'package:carrental/custom/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class buttons extends StatelessWidget
{
  final String btn_text;
  final VoidCallback? callBack;
  final double size;
  const buttons(
      this.btn_text,
      this.size,
      this.callBack,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          callBack!();
        },
        child: texts(btn_text, size, Colors.white, FontWeight.normal),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Colors.white),

      ),
    );

  }
}