import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UserRating extends StatefulWidget {
  @override
  _UserRatingState createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  var ratingList;
  var setrating = 0;
  TextEditingController review = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ratingList = ["1", "2", "3", "4", "5+"];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final rating = Container(
      height: width * 0.15,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: ratingList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                setrating = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  right: spacing_standard_new, top: spacing_control),
              decoration: boxDecoration(
                  radius: spacing_middle,
                  bgColor: setrating == index
                      ? Color(0xFF3B8BEA)
                      : Color(0xFFE8E8EC)),
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: text(ratingList[index],
                  textColor:
                      setrating == index ? Colors.white : Color(0xFF333333),
                  isCentered: true),
            ),
          );
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopBar("Write a Review"),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      left: spacing_standard_new, right: spacing_standard_new),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset("assets/rate.jpg",
                              height: width * 0.55, width: width * 0.55)),
                      SizedBox(height: spacing_standard_new),
                      Row(
                        children: [
                          text1("Rate this Food Item: ", fontFamily: "Medium",fontSize: 20.0),
                          text("*",textColor: Colors.red,fontSize: 20.0)
                        ],
                      ),
                      SizedBox(height: spacing_control),
                      rating,
                      SizedBox(height: spacing_standard_new),
                      Row(
                        children: [
                          text1("Write a Review: ", fontFamily: "Medium",fontSize: 20.0),
                          Text("(Optional)")
                        ],
                      ),
                      SizedBox(height: spacing_control),
                      TextField(
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black,)
                          ),
                          labelText: "Write a review..",
                          hintText: "write....",
                          hintStyle:
                              TextStyle(color: Colors.black),
                          labelStyle:
                              TextStyle(color: Colors.black),
                          alignLabelWithHint: true,
                          filled: true,
                        ),
                        controller: review,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: spacing_large),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: spacing_middle, bottom: spacing_middle),
                        decoration: boxDecoration(
                            bgColor: Color(0xFF3B8BEA),
                            radius: 50,
                            showShadow: true),
                        child: text("Add Review",
                            textColor: Colors.white, isCentered: true,fontSize: 15.0),
                      ),
                      SizedBox(height: spacing_standard_new),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
