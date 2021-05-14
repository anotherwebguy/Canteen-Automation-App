import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Admin/editproduct.dart';
import 'package:canteen_app/Helpers/extensions.dart';
import 'package:canteen_app/Helpers/percent_indicator.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Users/addRating.dart';
import 'package:canteen_app/Users/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:timeago/timeago.dart' as tAgo;

class Description extends StatefulWidget {
  final String image, name, description, amount, category, type, inv,docid;
  final num review, ratingcount, reviewcount, rate1, rate2, rate3, rate4, rate5;
  Description(
      {this.image,
      this.name,
      this.description,
      this.amount,
      this.category,
      this.review,
      this.type,
      this.inv,
      this.docid,
      this.rate1,
      this.rate2,
      this.rate3,
      this.rate4,
      this.rate5,
      this.ratingcount,
      this.reviewcount});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  var position = 0;
  bool isExpanded = false;
  var selectedColor = -1;
  var selectedSize = -1;
  double fiveStar = 0;
  double fourStar = 0;
  double threeStar = 0;
  double twoStar = 0;
  double oneStar = 0;
  int cartcounter = 1;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    // fetchData();
    fiveStar = widget.rate5.toDouble();
    fourStar = widget.rate4.toDouble();
    threeStar = widget.rate3.toDouble();
    twoStar = widget.rate2.toDouble();
    oneStar = widget.rate1.toDouble();
    counter = 0;
    checkForCart();
  }

  setRating() {
    fiveStar = (fiveStar * 100) / widget.ratingcount.toDouble();
    fourStar = (fourStar * 100) / widget.ratingcount.toDouble();
    threeStar = (threeStar * 100) / widget.ratingcount.toDouble();
    twoStar = (twoStar * 100) / widget.ratingcount.toDouble();
    oneStar = (oneStar * 100) / widget.ratingcount.toDouble();
    print(fiveStar);
  }

  Future<void> checkForCart() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .snapshots()
        .listen((event) {
      setState(() {
        counter = event.docs.length;
      });
    });
  }

  Widget mVegOption(var value, var iconColor) {
    return Row(
      children: <Widget>[
        Image.asset("assets/food_c_type.png",
            color: iconColor, width: 18, height: 18),
        SizedBox(width: spacing_standard),
        text(value),
      ],
    );
  }

  Widget cartIcon(context, cartCount) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: spacing_standard_new),
              padding: EdgeInsets.all(spacing_standard),
              child: Icon(Icons.shopping_cart)),
          counter > 0
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(top: spacing_control),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: text(counter.toString(),
                        textColor: Colors.white, fontSize: textSizeSmall),
                  ),
                )
              : Container()
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cart(
              length: counter,
            ),
          ),
        );
      },
      radius: spacing_standard_new,
    );
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);

    var width = MediaQuery.of(context).size.width;

    var sliderImages = Container(
      height: 340,
      child: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Hero(
            tag: "${widget.name}",
            child: CachedNetworkImage(
              imageUrl: widget.image,
              width: width,
              height: width * 1.05,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                child: Center(
                  child: new CupertinoActivityIndicator(),
                ),
              ),
            ),
          );
          //return Image.network(widget.image, width: width, height: width * 1.05, fit: BoxFit.cover,);
        },
        onPageChanged: (index) {
          position = index;
          setState(() {});
        },
      ),
    );

    var productInfo = Padding(
      padding: EdgeInsets.all(14),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text(widget.name,
                  textColor: Colors.black,
                  fontFamily: 'Medium',
                  fontSize: 22.0),
              text1(
                "\u{20B9}" + widget.amount + "  ",
                textColor: Colors.green,
                fontSize: 22.0,
                fontFamily: 'Medium',
              )
            ],
          ),
          SizedBox(height: spacing_standard),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(spacing_standard_new)),
                        color: widget.review < 2
                            ? Colors.red
                            : widget.review < 4
                                ? Colors.orange
                                : Colors.green,
                        //color: Colors.green
                      ),
                      child: Row(
                        children: <Widget>[
                          text(widget.review.toString(),
                              textColor: Colors.white),
                          SizedBox(width: spacing_control_half),
                          Icon(Icons.star, color: Colors.white, size: 12),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing_standard),
                    text(widget.reviewcount.toString() + "  Reviewes"),
                    // SizedBox(width: spacing_standard),
                    // text("\$"+widget.amount),
                    // SizedBox(width: spacing_standard),
                    // text(widget.category)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing_standard),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text(" " + widget.category),
              widget.inv=='instock'?text("In Stock", textColor: Colors.green, fontFamily: 'Medium', fontSize: 16.0):
              text("Out of Stock", textColor: Colors.red, fontFamily: 'Medium', fontSize: 16.0)
            ],
          ),
        ],
      ),
    );

    // var reviews = ListView.builder(
    //   scrollDirection: Axis.vertical,
    //   itemCount: list.length,
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (context, index) {
    //     return Container(
    //       margin: EdgeInsets.only(bottom: spacing_standard_new),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    // Container(
    //   padding: EdgeInsets.only(left: 12, right: 12, top: 1, bottom: 1),
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(spacing_standard_new)), color: list[index].rating < 2 ? Colors.red : list[index].rating < 4 ? Colors.orange : Colors.green),
    //   child: Row(
    //     children: <Widget>[text(list[index].rating.toString(), textColor: sh_white), SizedBox(width: spacing_control_half), Icon(Icons.star, color: sh_white, size: 12)],
    //   ),
    // ),
    //               SizedBox(width: spacing_standard_new),
    //               Expanded(
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     text(list[index].name, textColor: sh_textColorPrimary, fontSize: textSizeMedium, fontFamily: fontMedium),
    //                     text(list[index].review, fontSize: textSizeMedium),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //           SizedBox(height: spacing_standard),
    //           Image.asset("images/shophop/img/products" + widget.product.images[0].src, width: 90, height: 110, fit: BoxFit.fill),
    //           SizedBox(height: spacing_standard),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: <Widget>[
    //               Row(
    //                 children: <Widget>[
    //                   Container(
    //                     padding: EdgeInsets.all(4),
    //                     margin: EdgeInsets.only(right: spacing_standard),
    //                     decoration: BoxDecoration(shape: BoxShape.circle, color: list[index].verified ? Colors.green : Colors.grey.withOpacity(0.5)),
    //                     child: Icon(list[index].verified ? Icons.done : Icons.clear, color: sh_white, size: 14),
    //                   ),
    //                   text(list[index].verified ? sh_lbl_verified : sh_lbl_not_verified, textColor: sh_textColorPrimary, fontFamily: fontMedium, fontSize: textSizeMedium)
    //                 ],
    //               ),
    //               text("26 June 2019", fontSize: textSizeMedium)
    //             ],
    //           )
    //         ],
    //       ),
    //     );
    //   },
    // );

    var descriptionTab = Container(
      margin: EdgeInsets.all(spacing_standard_new),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            text(widget.description, maxLine: 3, isLongText: isExpanded),
            // Stack(
            //   alignment: Alignment.bottomRight,
            //   children: <Widget>[

            //   ],
            // ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(spacing_control_half),
                color: Colors.transparent,
                child: text1(isExpanded ? "Read Less ..." : "... Read More",
                    textColor: Color(0xFF212121), fontSize: textSizeMedium),
              ),
              onTap: () {
                isExpanded = !isExpanded;
                setState(() {});
              },
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            widget.type == null || widget.type == "veg"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: mVegOption("Veg only", Colors.green), flex: 1),
                      Expanded(
                          child: mVegOption("Non-Veg only", Color(0xFFDADADA)),
                          flex: 2),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: mVegOption("Veg only", Color(0xFFDADADA)),
                          flex: 1),
                      Expanded(
                          child: mVegOption("Non-Veg only", Colors.red),
                          flex: 2),
                    ],
                  ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            role == "user"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text1("Quantity: ", fontSize: 20.0),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: 100,
                          //decoration: boxDecoration4(color: Colors.black, radius: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 35,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xFF333333),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4.0),
                                        topLeft: Radius.circular(4.0))),
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: Color(0xFFffffff), size: 10),
                                  onPressed: () {
                                    setState(() {
                                      if (cartcounter == 1 || cartcounter < 1) {
                                        cartcounter = 1;
                                      } else {
                                        cartcounter = cartcounter - 1;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Text("$cartcounter"),
                              Container(
                                width: 35,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xFF333333),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0))),
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: Color(0xFFffffff), size: 10),
                                  onPressed: () {
                                    setState(() {
                                      cartcounter = cartcounter + 1;
                                      print(cartcounter);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );

    var reviewscontainer = Container(
        child: Column(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('All')
                .doc(widget.docid)
                .collection("reviews")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('We got an Error ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Container(
                      child: Theme(
                        data: ThemeData.light(),
                        child: CupertinoActivityIndicator(
                          animating: true,
                          radius: 20,
                        ),
                      ),
                    ),
                  );

                case ConnectionState.none:
                  return Text('oops no data');

                case ConnectionState.done:
                  return Text('We are Done');
                default:
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot reviews = snapshot.data.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 10),
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  reviews.data()['image'],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          text(reviews.data()['name'],
                                              fontSize: 15.0,
                                              fontFamily: "Bold"),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                            top: 1,
                                            bottom: 1),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    spacing_standard_new)),
                                            color: reviews.data()['rating'] < 2
                                                ? Colors.red
                                                : reviews.data()['rating'] < 4
                                                    ? Colors.orange
                                                    : Colors.green),
                                        child: Row(
                                          children: <Widget>[
                                            text(
                                                reviews
                                                    .data()['rating']
                                                    .toString(),
                                                textColor: Colors.white),
                                            SizedBox(
                                                width: spacing_control_half),
                                            Icon(Icons.star,
                                                color: Colors.white, size: 12)
                                          ],
                                        ),
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: text1(
                                          reviews.data()['review'],
                                          maxLine: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        (tAgo.format(reviews
                                                .data()['time']
                                                .toDate()))
                                            .toString(),
                                        style: secondaryTextStyle(),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        );
                      });
              }
            }),
      ],
    ));

    var reviewsTab = SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 60),
      child: Container(
        margin: EdgeInsets.only(left: 16, top: 20, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(spacing_standard_new),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: width * 0.33,
                    width: width * 0.33,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //reviewText("3", size: 28.0, fontSize: 30, fontFamily: 'Bold'),
                        reviewText(widget.review,
                            size: 28.0, fontSize: 30.0, fontFamily: 'Bold'),
                        text1(widget.reviewcount.toString() + " Reviews",
                            fontSize: 14.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            reviewText(5.0),
                            ratingProgress(fiveStar, Colors.green)
                          ],
                        ),
                        SizedBox(
                          height: spacing_control_half,
                        ),
                        Row(
                          children: <Widget>[
                            reviewText(4.0),
                            ratingProgress(fourStar, Colors.green)
                          ],
                        ),
                        SizedBox(
                          height: spacing_control_half,
                        ),
                        Row(
                          children: <Widget>[
                            reviewText(3.0),
                            ratingProgress(threeStar, Colors.amber)
                          ],
                        ),
                        SizedBox(
                          height: spacing_control_half,
                        ),
                        Row(
                          children: <Widget>[
                            reviewText(2.0),
                            ratingProgress(twoStar, Colors.amber)
                          ],
                        ),
                        SizedBox(
                          height: spacing_control_half,
                        ),
                        Row(
                          children: <Widget>[
                            reviewText(1.0),
                            ratingProgress(oneStar, Colors.red)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                text("Reviews",
                    textColor: Color(0xFF212121),
                    fontFamily: 'Medium',
                    fontSize: textSizeNormal),
                role == "user"
                    ? MaterialButton(
                        textColor: Color(0xFF3d87ff),
                        padding: EdgeInsets.only(
                            left: spacing_standard_new,
                            right: spacing_standard_new,
                            top: 0,
                            bottom: 0),
                        child: text1("Rate Now",
                            fontSize: textSizeMedium,
                            textColor: Color(0xFF3d87ff)),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              new BorderRadius.circular(spacing_large),
                          side: BorderSide(color: Color(0xFF3d87ff)),
                        ),
                        onPressed: () {
                          //showRatingDialog(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserRating(
                                rating: widget.review,
                                docid: widget.docid,
                                rate1: widget.rate1,
                                rate2: widget.rate2,
                                rate3: widget.rate3,
                                rate4: widget.rate4,
                                rate5: widget.rate5,
                                ratingcount: widget.ratingcount,
                                reviewcount: widget.reviewcount,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(height: 3),
            ),
            // reviewscontainer
            widget.reviewcount != 0
                ? reviewscontainer
                : Container(
                    height: 200,
                    child: Center(
                        child: text1(
                      "No reviews yet... :'(",
                      fontSize: 30.0,
                    ))),
            // reviews
          ],
        ),
      ),
    );

    var noreviews = Container(
      color: Colors.red,
    );

    var bottombuttons = Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: boxDecoration4(
                showShadow: true, radius: 0, bgColor: Color(0xFFffffff)),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        text1("Edit the Food Item",
                            fontFamily: "Medium", fontSize: 16.0),
                      ],
                    ),
                    //text("View Bill Details", textColor: Color(0xFF3B8BEA)),
                    role == "user"
                        ? GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 200,
                                    // color: Colors.white,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0))),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top:
                                                      20.0 / 4), //top padding 5
                                              height: 4,
                                              width: 60,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Items: ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Regular",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    text1(widget.name,
                                                        fontSize: 20.0),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Quantities: ",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Regular",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    text1(
                                                        cartcounter.toString(),
                                                        fontSize: 20.0),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Total price:                     " +
                                                  (int.parse(widget.amount) *
                                                          cartcounter)
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Regular",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              "View Details",
                              style: TextStyle(
                                  color: Color(0xFF3B8BEA),
                                  fontSize: 18.0,
                                  fontFamily: "Regular",
                                  letterSpacing: 0.5,
                                  height: 1.5,
                                  decoration: TextDecoration.underline),
                            ))
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                ),
                role == "user"
                    ? GestureDetector(
                        onTap: () async {
                          
                          await addFoodItemToCart(
                              widget.name,
                              cartcounter.toString(),
                              (int.parse(widget.amount) * cartcounter)
                                  .toString(),
                              widget.type,
                              widget.image);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text("Confirmation",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              content: Text(
                                "This Food Item has been added to your cart",
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: widget.inv=="instock"?Container(
                          padding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                          decoration: gradientBoxDecoration(
                              radius: 50,
                              showShadow: true,
                              gradientColor1: Color(0xFF3B8BEA),
                              gradientColor2: Color(0xFF3F77DE)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Add to Cart",
                                    style: TextStyle(
                                        fontFamily: "Medium",
                                        fontSize: 16.0,
                                        color: Color(0xFFffffff))),
                                WidgetSpan(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.add_shopping_cart,
                                          color: Color(0xFFffffff), size: 18)),
                                ),
                              ],
                            ),
                          ),
                        ):Container(),
                ): GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                        name: widget.name,
                                        description: widget.description,
                                        price: widget.amount,
                                        type: widget.type,
                                        inv: widget.inv,
                                        category: widget.category,
                                        image: widget.image,
                                        docid: widget.docid,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                          decoration: gradientBoxDecoration(
                              radius: 50,
                              showShadow: true,
                              gradientColor1: Color(0xFF3B8BEA),
                              gradientColor2: Color(0xFF3F77DE)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Edit",
                                    style: TextStyle(
                                        fontFamily: "Medium",
                                        fontSize: 16.0,
                                        color: Color(0xFFffffff))),
                                WidgetSpan(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.edit_outlined,
                                          color: Color(0xFFffffff), size: 18)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                changeStatusColor(
                    innerBoxIsScrolled ? Colors.white : Colors.transparent);
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 440,
                    floating: true,
                    pinned: true,
                    titleSpacing: 0,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Color(0xFF212121)),
                    actionsIconTheme: IconThemeData(color: Color(0xFF212121)),
                    actions: <Widget>[
                      // Container(
                      //   padding: EdgeInsets.all(spacing_standard),
                      //   margin: EdgeInsets.only(right: spacing_standard_new),
                      //   decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.grey.withOpacity(0.1)),
                      //   child: Icon(Icons.favorite_border,
                      //       color: Color(0xFF212121), size: 18),
                      // ),
                      role == "user"
                          ? cartIcon(context, 3)
                          : SizedBox(width: 0),
                    ],
                    title: text(widget.name,
                        textColor: innerBoxIsScrolled == false
                            ? Colors.transparent
                            : Color(0xFF212121),
                        fontSize: textSizeNormal,
                        fontFamily: 'Medium'),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        children: <Widget>[
                          sliderImages,
                          productInfo,
                        ],
                      ),
                      collapseMode: CollapseMode.pin,
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelColor: Color(0xFF3d87ff),
                        indicatorColor: Color(0xFF3d87ff),
                        unselectedLabelColor: Color(0xFF212121),
                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "Reviews"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  descriptionTab,
                  reviewsTab,
                ],
              ),
            ),
          ),
          bottombuttons,
        ],
      ),
    );
  }

  Widget reviewText(rating,
      {size = 15.0,
      fontSize = textSizeLargeMedium,
      fontFamily = 'Medium',
      textColor = const Color(0xFF212121)}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        text(rating.toString(),
            textColor: textColor, fontFamily: fontFamily, fontSize: fontSize),
        SizedBox(width: spacing_control),
        Icon(Icons.star, color: Colors.amber, size: size)
      ],
    );
  }

  Widget ratingProgress(value, color) {
    return Expanded(
      child: LinearPercentIndicator(
        lineHeight: 10.0,
        percent: value / 100,
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: Colors.grey.withOpacity(0.2),
        progressColor: color,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: Colors.white,
      child: Container(child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
