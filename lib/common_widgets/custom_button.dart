import 'package:flutter/material.dart';

Widget defaultbutton({
  double width = double.infinity,
  Color background = Colors.white,
  bool isUpperCase = true,
  double? radius,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xff2B475E),
            fontSize: 20,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius!,
        ),
        color: background,
      ),
    );
