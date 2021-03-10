import 'package:flutter/material.dart';

Widget text(
    String text, {
      var fontSize = 14.0,
      textColor = const Color(0xFF212121),
      var fontFamily = 'Regular',
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.25,
      var textAllCaps = false,
      var isLongText = false,
      var fontweight = FontWeight.bold,
    }) {
  return Text(textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      style: TextStyle(fontFamily: fontFamily, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing,fontWeight: fontweight));
}

Widget text1(
    String text, {
          var fontSize = 14.0,
          textColor = const Color(0xFF212121),
          var fontFamily = 'Regular',
          var isCentered = false,
          var maxLine = 1,
          var latterSpacing = 0.25,
          var textAllCaps = false,
          var isLongText = false,
    }) {
      return Text(textAllCaps ? text.toUpperCase() : text,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          maxLines: isLongText ? null : maxLine,
          style: TextStyle(fontFamily: fontFamily, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing));
}

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow ? [BoxShadow(color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}
