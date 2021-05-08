import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderContainer extends StatefulWidget {
  final int index;
  final String name,
      image,
      phone,
      totalamount,
      status,
      statusid,
      ordertime,
      time,
      docid;
  OrderContainer(
      {this.index,
      this.name,
      this.image,
      this.phone,
      this.totalamount,
      this.status,
      this.statusid,
      this.ordertime,
      this.time,
      this.docid});
  @override
  _OrderContainerState createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  bool visibility = false;

  void _changed() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget details(String docid) {
      return Container(
          child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .doc(docid)
                  .collection("cart")
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
                          DocumentSnapshot details = snapshot.data.docs[index];
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          details.data()['image'],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          text1(details.data()['quantity'] +
                                              "x "),
                                          text1(details.data()['name'])
                                        ],
                                      )
                                    ],
                                  ),
                                  text1(details.data()['amount'] + " Rs",
                                      textColor: Colors.green)
                                ],
                              ));
                        });
                }
              }),
        ],
      ));
    }

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
                              fontSize: 13.0,
                              textColor: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            role == "user"
                                ? Icon(Icons.phone)
                                : SizedBox(width: 10),
                            SizedBox(width: 5),
                            text1(widget.phone, textColor: Colors.black38),
                          ],
                        ),
                        role == "admin"
                            ? IconButton(
                                icon: Icon(Icons.phone),
                                onPressed: () async {
                                  await launch("tel:${widget.phone}");
                                })
                            : SizedBox(width: 0),
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
                    text1(widget.status, textColor: Colors.orange)
                  ],
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Confirmed",
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
            role == "user"
                ? GestureDetector(
                    onTap: () {
                      final popup = BeautifulPopup(
                        context: context,
                        template: TemplateGreenRocket,
                      );
                      popup.show(
                        title: "Scan Barcode.",
                        content: Center(
                          child: Container(
                            height: 55,
                            child: SfBarcodeGenerator(
                                  value: widget.statusid,
                                  symbology: Code128(),
                                ),
                          ),
                        ),
                        // actions: [
                        //   popup.button(
                        //       label: "Delivered?", onPressed: () async {}),
                        // ],
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          //width: 70,
                          height: 55,
                          //color: Colors.black26,
                          child: SfBarcodeGenerator(
                            value: widget.statusid,
                            symbology: Code128(),
                            //showValue: true,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text1("Tap to Scan the Barcode",
                                textColor: Colors.black38),
                          ],
                        ),
                      ],
                    ))
                : SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                text1(widget.time.substring(0, 16), textColor: Colors.black87)
              ],
            ),
            Visibility(
              visible: visibility,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text("                       Orders"),
                        text("Price/-")
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        height: 5,
                      ),
                    ),
                    details(widget.docid),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _changed();
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.keyboard_arrow_up,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              replacement: GestureDetector(
                onTap: () {
                  _changed();
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  text1("Expand to view order details"),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
