import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:flutter/material.dart';

class UserHistory extends StatefulWidget {
  final int index;
  final String name,
      image,
      phone,
      totalamount,
      status,
      statusid,
      ordertime,
      time;
  UserHistory(
      {this.index,
      this.name,
      this.image,
      this.phone,
      this.totalamount,
      this.status,
      this.statusid,
      this.ordertime,
      this.time});
  @override
  _UserHistoryState createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      decoration: boxDecoration5(
          showShadow: true, bgColor: Colors.white, radius: spacing_middle),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                ClipRRect(
                  borderRadius: new BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.fill,
                    height: width * 0.22,
                    width: width * 0.29,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 2),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: text(widget.name,
                              fontFamily: "Bold",
                              fontSize: 15.0,
                              textColor: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 5),
                            text1(widget.phone, textColor: Colors.black38),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text("Order Total Amount:"),
                text1(widget.totalamount, textColor: Colors.blue),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text("Order slot:"),
                text1(widget.ordertime, textColor: Colors.orange),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    text("Pyment Method: ", textColor: Colors.black),
                    text1(widget.status, textColor: Colors.blue)
                  ],
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Delivered",
                        style: TextStyle(
                            fontSize: textSizeMedium, color: Colors.green)),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text1(widget.time.substring(0, 16), textColor: Colors.black87)
              ],
            ),
          ],
        ),
      ),
    );
  }
}