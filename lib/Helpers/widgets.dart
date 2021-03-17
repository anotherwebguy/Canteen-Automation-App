import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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

Widget text2(var text,
    {var fontSize = 18.0, textColor =const Color(0xFF838591), var fontFamily = 'Regular', var isCentered = false, var maxLine = 1, var latterSpacing = 0.1, overflow: Overflow}) {
  return Text(text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: maxLine,
      style: TextStyle(fontFamily: fontFamily, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing));
}

Widget toolBarTitle(var title,{textColor=const Color(0xFF1e253a)}){
  return text(title,fontSize: 20.0,fontFamily: 'Bold',textColor: textColor);
}

Widget appBar(context,var title,{actions}){
  return AppBar(
    title: toolBarTitle(title),
    leading: Icon(Icons.arrow_back_ios).onTap((){
      Navigator.pop(context);
    }),
    titleSpacing:0,
    iconTheme: IconThemeData(color: Color(0xFF1e253a)),
    backgroundColor: Colors.white.withOpacity(0.1),
    elevation: 0,
    actions: actions,
  );
}

BoxDecoration boxDecoration({double radius = 2, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow ? [BoxShadow(color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

BoxDecoration boxDecoration1({double radius = 2, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

BoxDecoration boxDecoration2(
    {double radius = 2,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [BoxShadow(color: Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

Widget mHeading(var value) {
  return Container(
    margin: EdgeInsets.all(16.0),
    child: text(value, fontFamily: 'Medium', textAllCaps: true),
  );
}

Widget mViewAll(BuildContext context, var value, {var tags}) {
  return GestureDetector(
    onTap: () {
      if (tags != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => tags));
      } //launchScreen(context, tags);
    },
    child: Container(
      margin: EdgeInsets.only(left:16.0,right: 16.0,top: 0,bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.arrow_forward, color: Color(0xFF3B8BEA), size: 18)),
            ),
            TextSpan(text: value, style: TextStyle(fontSize: 16.0, color: Color(0xFF3B8BEA))),
          ],
        ),
      ),
    ),
  );
}



Widget formField( context,hint,
    {isEnabled = true,
      isDummy = false,
      controller,
      isPasswordVisible = false,
      isPassword = false,
      keyboardType,
      FormFieldValidator<String> validator,
      onSaved,
      textInputAction = TextInputAction.next,
      FocusNode focusNode,
      FocusNode nextFocus,
      IconData suffixIcon,
      IconData prefixIcon,
      maxLine = null,
      suffixIconSelector}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword?isPasswordVisible:false,
    cursorColor: Color(0xFF3d87ff),
    maxLines: maxLine,
    keyboardType: keyboardType,
    validator: validator,
    onSaved: onSaved,
    textInputAction: textInputAction,
    focusNode: focusNode,
    onFieldSubmitted: (arg) {
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    },
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.transparent)

      ),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.transparent)

      ),
      filled: true,
      fillColor: Color(0xFFfafafa),
      hintText:hint,
      hintStyle: TextStyle(
          fontSize: 14.0, color: Color(0xFF838591)),
      prefixIcon:Icon(
        prefixIcon,
        color: Color(0xFF838591),
        size: 20,
      ) ,
      suffixIcon: isPassword
          ? GestureDetector(
        onTap: suffixIconSelector,
        child: new Icon(
          suffixIcon,
          color: Color(0xFF838591),
          size: 20,
        ),
      )
          : Icon(
        suffixIcon,
        color: Color(0xFF838591),
        size: 20,
      ),
    ),
    style: TextStyle(
        fontSize: 20.0,
        color: isDummy
            ? Colors.transparent
            : Color(0xFF1e253a),
        fontFamily: 'Regular'),
  );
}

