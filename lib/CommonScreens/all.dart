import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/CommonScreens/description.dart';
import 'package:canteen_app/CommonScreens/search.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/flutter_rating_bar.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:canteen_app/Users/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllCat extends StatefulWidget {
  @override
  _AllCatState createState() => _AllCatState();
}

class _AllCatState extends State<AllCat> {
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = 0;
    checkForCart();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("All Categories", fontSize: 22.0, fontFamily: 'Regular'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
          ),
          role == "user" ? Stack(
            children: <Widget>[
              new IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(
                        length: counter,
                      ),
                    ),
                  );
                },
              ),
              counter != 0
                  ? new Positioned(
                      right: 11,
                      top: 11,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : new Container()
            ],
          ) : SizedBox(width: 0),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('All').snapshots(),
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
                        return Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              primary: false,
                              padding: EdgeInsets.only(bottom: 30),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              shrinkWrap: true,
                              staggeredTileBuilder: (index) =>
                                  new StaggeredTile.fit(2),
                              itemCount: snapshot.data.docs.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot all =
                                    snapshot.data.docs[index];
                                print(snapshot.data.docs[index].id);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Description(
                                                  image: all.data()['image'],
                                                  name: all.data()['Itemname'],
                                                  description:
                                                      all.data()['description'],
                                                  amount: all.data()['amount'],
                                                  category:
                                                      all.data()['category'],
                                                  review: all.data()['rating'],
                                                  type: all.data()['type'],
                                                  inv: all.data()['stock'],
                                                  docid: all.id,
                                                  rate1:
                                                      all.data()['rate1'],
                                                  rate2:
                                                      all.data()['rate2'],
                                                  rate3:
                                                      all.data()['rate3'],
                                                  rate4:
                                                      all.data()['rate4'],
                                                  rate5:
                                                      all.data()['rate5'],
                                                  ratingcount: all
                                                      .data()['ratingcount'],
                                                  reviewcount: all
                                                      .data()['reviewcount'],
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 4, bottom: 4, right: 4, top: 4),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          child: Hero(
                                            tag: "${all.data()['Itemname']}",
                                            child: CachedNetworkImage(
                                              imageUrl: all.data()['image'],
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        text1(all.data()['Itemname'],
                                            textColor: Colors.black,
                                            fontSize: textSizeLargeMedium,
                                            fontFamily: 'Bold'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            text1(
                                              all.data()['amount'] + " Rs",
                                              fontSize: textSizeMedium,
                                              textColor: Colors.green,
                                            ),
                                            RatingBar(
                                              initialRating: all
                                                  .data()['rating']
                                                  .toDouble(),
                                              minRating: 1,
                                              itemSize: 16,
                                              direction: Axis.horizontal,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
