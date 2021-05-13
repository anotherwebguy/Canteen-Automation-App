import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/CommonScreens/description.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/flutter_rating_bar.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String Searchstring;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFf8f8f8),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: boxDecorations(
                          radius: 6,
                          bgColor: Color(0xFFDADADA).withOpacity(0.8),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              Searchstring = val;
                            });
                          },
                          controller: textEditingController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Cancel",
                          style:
                              primaryTextStyle1(textColor: Color(0xFF3281FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    "Search for your Favourites",
                    style: secondaryTextStyle(),
                  )),
              SizedBox(
                height: 10,
              ),
              Column(children: [
                StreamBuilder<QuerySnapshot>(
                  stream: (Searchstring == null || Searchstring.trim() == '')
                      ? FirebaseFirestore.instance.collection("All").snapshots()
                      : FirebaseFirestore.instance
                          .collection("All")
                          .where('searchString',
                              arrayContains: Searchstring.toLowerCase())
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
                                          child: CachedNetworkImage(
                                            imageUrl: all.data()['image'],
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
                  },
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
