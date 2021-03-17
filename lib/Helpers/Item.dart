import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Helpers/flutter_rating_bar.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  String name,image,price;
  int rating;
  Item({this.name,this.image,this.price,this.rating});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: width * 0.4,
        margin: EdgeInsets.only(left: 16.0),
        decoration: boxDecoration(showShadow: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  topLeft: Radius.circular(4.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: image,
                      height: width * 0.3,
                      width: width * 0.4,
                      fit: BoxFit.cover),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.favorite_border,
                        color: Colors.white, size: 18),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text1(name,
                      fontFamily: 'Medium', maxLine: 2, isCentered: false),
                  SizedBox(height: 3,),
                  text1("\$"+price.toString(),
                      fontFamily: 'Medium', maxLine: 1, isCentered: false),
                  Row(
                    children: <Widget>[
                      RatingBar(
                        initialRating: rating.toDouble(),
                        minRating: 1,
                        itemSize: 16,
                        direction: Axis.horizontal,
                        itemPadding:
                        EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                  text1("review",
                      textColor: Color(0xFF949292),
                      fontSize: 14.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}