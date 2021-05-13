import 'package:canteen_app/Helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
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

BoxDecoration ratingbox({double radius = 2, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? [BoxShadow(color: Color(0X95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
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

BoxDecoration boxDecoration4({double radius = 10.0, Color color = Colors.transparent, Color bgColor = const Color(0xFFffffff), var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? [BoxShadow(color: Color(0X95E9EBF0), blurRadius: 6, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration gradientBoxDecoration({double radius = 10.0, Color color = Colors.transparent, Color gradientColor2 = const Color(0xFFffffff), Color gradientColor1 = const Color(0xFFffffff), var showShadow = false}) {
  return BoxDecoration(
    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [gradientColor1, gradientColor2]),
    boxShadow: showShadow ? [BoxShadow(color: Color(0X95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration mobile({double radius = spacing_middle, Color color = Colors.transparent, Color bgColor = Colors.white,var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? [BoxShadow(color: Color(0X95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget mTop(BuildContext context, var title, {var tags}) {
  var width = MediaQuery.of(context).size.width;
  return Container(
    width: MediaQuery.of(context).size.width,
    height: width * 0.15,
    color: Colors.white,
    child: Stack(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: spacing_standard_new),
                width: width * 0.1,
                height: width * 0.1,
                decoration: mobile(showShadow: false, bgColor: Color(0xFF494FFB)),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
              ),
            )),
        Center(
          child: text(title, fontFamily: 'Bold', fontSize: textSizeLargeMedium, textAllCaps: true),
        ),
      ],
    ),
  );
}


TextStyle primaryTextStyle1(
    {int size = 16, Color textColor = const Color(0xFF000000)}) {
  return TextStyle(
    fontSize: size.toDouble(),
    color: textColor,
  );
}

TextStyle secondaryTextStyle(
    {int size = 14, Color textColor = const Color(0xFF757575)}) {
  return TextStyle(
    fontSize: size.toDouble(),
    color: textColor,
  );
}


BoxDecoration boxDecorations(
    {double radius = 8,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      //gradient: LinearGradient(colors: [bgColor, whiteColor]),
      boxShadow: showShadow
          ? [BoxShadow(color:  Color(0x95E9EBF0), blurRadius: 10, spreadRadius: 2)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

class TopBar extends StatefulWidget {
  var titleName;

  TopBar(var this.titleName);

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Center(child: text(widget.titleName, fontFamily: 'Bold', fontSize: textSizeLargeMedium, isCentered: true)),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration boxDecoration5({double radius = spacing_middle, Color color = Colors.transparent, Color bgColor = Colors.white, var showShadow = false}) {
  return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow ? [BoxShadow(color:  Color(0X95E9EBF0), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)));
}

InputDecoration formFieldDecoration(String hint_text) {
  return InputDecoration(
    labelText: hint_text,
    focusColor: Color(0xFFf17015),
    counterText: "",
    labelStyle: TextStyle(fontFamily: "Regular", fontSize: textSizeMedium),
    contentPadding: new EdgeInsets.only(bottom: 2.0),
  );
}
