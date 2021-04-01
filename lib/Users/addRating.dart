import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UserRating extends StatefulWidget {
  final String docid;
  final num rating, ratingcount, reviewcount, rate1, rate2, rate3, rate4, rate5;
  UserRating(
      {this.rating,
      this.docid,
      this.rate1,
      this.rate2,
      this.rate3,
      this.rate4,
      this.rate5,
      this.ratingcount,
      this.reviewcount});
  @override
  _UserRatingState createState() => _UserRatingState();
}

class _UserRatingState extends State<UserRating> {
  var ratingList;
  var setrating = 0;
  bool isLoading=false;
  bool change =false;
  TextEditingController review = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ratingList = ["1", "2", "3", "4", "5+"];
    review.text="";
  }

  Future<void> updateAllrating()async{
    num five=widget.rate5,four=widget.rate4,three=widget.rate3,two=widget.rate2,one=widget.rate1;
    num avgrating = (widget.rate1+widget.rate2+widget.rate3+widget.rate4+widget.rate5+1)/ 5;
    switch (setrating) {
        case 4:
          five++;
          break;
        case 3:
          four++;
          break;
        case 2:
          three++;
          break;
        case 1:
          two++;
          break;
        case 0:
          one++;
          break;
      }
    return await FirebaseFirestore.instance.collection("All").doc(widget.docid).update({
      "rating": num.parse(avgrating.toStringAsFixed(1)),
      "rate5": five,
      "rate4": four,
      "rate3": three,
      "rate2": two,
      "rate1": one
    });

  }

  Future<void> loadDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          title: Text('Thank you :) for rating this Food Item.\nPlease wait...'),
          actions: <Widget>[
            Center(
                child: Container(
                    child: Theme(
                    data: ThemeData.light(),
                    child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 20,
                      ),
                    ),
                ),
            ),
          ],
        );
      },
    );
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
                          text1("Rate this Food Item: ",
                              fontFamily: "Medium", fontSize: 20.0),
                          text("*", textColor: Colors.red, fontSize: 20.0)
                        ],
                      ),
                      SizedBox(height: spacing_control),
                      rating,
                      SizedBox(height: spacing_standard_new),
                      Row(
                        children: [
                          text1("Write a Review: ",
                              fontFamily: "Medium", fontSize: 20.0),
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
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black,
                              )),
                          labelText: "Write a review..",
                          hintText: "write....",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                          alignLabelWithHint: true,
                          filled: true,
                        ),
                        controller: review,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        onChanged: (String value) async{
                          change=true;
                        } ,
                      ),
                      SizedBox(height: spacing_large),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                               isLoading=true;
                            });
                            if (isLoading) {
                              loadDialog();
                            }
                          if (change) {
                             addReviews(name,review.text,setrating,profileimg,widget.docid);
                             incrementReviewCount(widget.docid);
                             incrementRatingCount(widget.docid);
                             updateAllrating();
                          } else {
                             incrementRatingCount(widget.docid);
                             updateAllrating();
                          }
                          Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          padding: EdgeInsets.only(
                              top: spacing_middle, bottom: spacing_middle),
                          decoration: boxDecoration(
                              bgColor: Color(0xFF3B8BEA),
                              radius: 50,
                              showShadow: true),
                          child: text("Add Review",
                              textColor: Colors.white,
                              isCentered: true,
                              fontSize: 15.0),
                        ),
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
