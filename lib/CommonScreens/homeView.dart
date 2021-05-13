import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Admin/addproduct.dart';
import 'package:canteen_app/Admin/adminDrawer.dart';
import 'package:canteen_app/Authentications/dashboard.dart';
import 'package:canteen_app/CommonScreens/all.dart';
import 'package:canteen_app/CommonScreens/categories.dart';
import 'package:canteen_app/CommonScreens/description.dart';
import 'package:canteen_app/CommonScreens/notifications.dart';
import 'package:canteen_app/CommonScreens/search.dart';
import 'package:canteen_app/Helpers/Item.dart';
import 'package:canteen_app/Helpers/collection.dart';
import 'package:canteen_app/Helpers/dataGenerator.dart';
import 'package:canteen_app/Helpers/extensions.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Model/categoryModel.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:canteen_app/Services/signin.dart';
import 'package:canteen_app/Users/cart.dart';
import 'package:canteen_app/Users/userDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Helpers/flutter_rating_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<CategoryModel> Listings1;
  List<DashboardCollections> dashlistings;
  bool isPress = false;
  AuthService _auth = new AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int counter = 0;
  int count = 0;

  final FlutterLocalNotificationsPlugin notify =
      new FlutterLocalNotificationsPlugin();

  bool one = false;

  Future<void> checkForNotification() async {
    int channelCount = 0;
    try {
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('notifications')
          .where('existence', isEqualTo: true)
          .snapshots()
          .listen((event) {
        event.docChanges.forEach((element) {
          if (element.type == DocumentChangeType.added &&
              element.doc.data()['existence'] == true) {
            _showNotification(element.doc.data()['title'],
                element.doc.data()['body'], element.doc.id);
            updateNotification(element.doc.id);
            setState(() {
              count++;
            });
            print(count);
            print(element.doc.id);
          }
        });
      });
    } catch (e) {
      print("error");
    }
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotification(
      String title, String body, String channelCount) async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("app_icon"),
        largeIcon: DrawableResourceAndroidBitmap("app_icon"),
        contentTitle: title,
        summaryText: body,
        htmlFormatContent: true,
        htmlFormatContentTitle: true);
    var androidDetails = new AndroidNotificationDetails(
        channelCount, "InstaFood", "This is my channel",
        importance: Importance.max, styleInformation: bigPicture);

    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);
    await notify.show(0, title, body, generalNotificationDetails,
        payload: title + "\n" + body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      Listings1 = getFilterFavourites();
      dashlistings = addCollectionData();
      counter = 0;
      count = 0;
      checkForCart();
      var androidInitilize = new AndroidInitializationSettings('app_icon');
      var iOSinitilize = new IOSInitializationSettings();
      var initilizationsSettings = new InitializationSettings(
          android: androidInitilize, iOS: iOSinitilize);
      notify.initialize(initilizationsSettings,
          onSelectNotification: notificationSelected);
      checkForNotification();
    } catch (e) {
      print("error");
    }
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
    changeStatusColor(Colors.transparent);
    double expandHeight = MediaQuery.of(context).size.height * 0.33;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colors.white,
            )),
        drawer: role == "user" ? UserDrawer() : AdminDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandHeight,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                titleSpacing: 0,
                backgroundColor:
                    innerBoxIsScrolled ? Color(0xFFffffff) : Color(0xFFffffff),
                actionsIconTheme: IconThemeData(opacity: 0.0),
                title: Container(
                  height: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            // IconButton(
                            //   icon: Icon(Icons.menu, color: Colors.black,size: 25,),
                            //   onPressed: () {
                            //     _scaffoldKey.currentState.openDrawer();
                            //   },
                            // ),
                            SizedBox(
                              width: 10,
                            ),
                            text('Home',
                                textColor: Colors.black,
                                fontSize: 25.0,
                                fontFamily: 'Bold'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search()));
                              },
                            ),
                            Stack(
                              children: <Widget>[
                                new IconButton(
                                  icon: Icon(
                                    Icons.notifications_active,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      count = 0;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Notifications(),
                                      ),
                                    );
                                  },
                                ),
                                count != 0
                                    ? new Positioned(
                                        right: 11,
                                        top: 11,
                                        child: new Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 14,
                                            minHeight: 14,
                                          ),
                                          child: Text(
                                            '$count',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        right: 11,
                                        top: 11,
                                        child: new Container())
                              ],
                            ),
                            role == "user"
                                ? Stack(
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
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                          : Positioned(
                                              right: 11,
                                              top: 11,
                                              child: new Container())
                                    ],
                                  )
                                : SizedBox(width: 0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                  height: expandHeight,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: PageView(
                          children: <Widget>[
                            InstaSlider(
                              img: "assets/home2.jpg",
                              heading: "Hii, " + name + "!!",
                              subheading: "~Where tasteful creations begin.",
                            ),
                            InstaSlider(
                              img: "assets/home6.jpg",
                              heading: "Hii, " + name + "!!",
                              subheading: "~Where tasteful creations begin.",
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ];
          },
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Color(0xFFf8f8f8),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 5.0, height: 50.0),
                      TyperAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: ["Feeling Hungry? Try InstaFood!!!"],
                          textStyle: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Bold",
                              color: Colors.green),
                          textAlign: TextAlign.start),
                      SizedBox(width: 5.0, height: 50.0),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 160,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, bottom: 16),
                              child: text1("Filter your Category",
                                  fontSize: 20.0, fontFamily: 'Medium'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: Listings1.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Filter(Listings1[index], index);
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: boxDecoration(showShadow: true, radius: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mHeading("Fast Food"),
                            mViewAll(context, "View All",
                                tags: Categories(
                                  category: "FastFood",
                                )),
                          ],
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('All')
                                .where("category", isEqualTo: "FastFood")
                                .limit(4)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'We got an Error ${snapshot.error}');
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
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        top: 2.0,
                                        bottom: 4.0),
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.docs.length,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot fastfood =
                                              snapshot.data.docs[index];
                                          print(snapshot.data.docs[index].id);
                                          String name =
                                              fastfood.data()['Itemname'];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Description(
                                                            image:
                                                                fastfood.data()[
                                                                    'image'],
                                                            name:
                                                                fastfood.data()[
                                                                    'Itemname'],
                                                            description: fastfood
                                                                    .data()[
                                                                'description'],
                                                            amount:
                                                                fastfood.data()[
                                                                    'amount'],
                                                            category:
                                                                fastfood.data()[
                                                                    'category'],
                                                            inv: fastfood.data()['stock'],
                                                            review:
                                                                fastfood.data()[
                                                                    'rating'],
                                                            type: fastfood
                                                                .data()['type'],
                                                            docid: fastfood.id,
                                                            rate1:
                                                                fastfood.data()[
                                                                    'rate1'],
                                                            rate2:
                                                                fastfood.data()[
                                                                    'rate2'],
                                                            rate3:
                                                                fastfood.data()[
                                                                    'rate3'],
                                                            rate4:
                                                                fastfood.data()[
                                                                    'rate4'],
                                                            rate5:
                                                                fastfood.data()[
                                                                    'rate5'],
                                                            ratingcount: fastfood
                                                                    .data()[
                                                                'ratingcount'],
                                                            reviewcount: fastfood
                                                                    .data()[
                                                                'reviewcount'],
                                                          )));
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 16),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: width * 0.32,
                                                    width: width * 0.32,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  12.0),
                                                          child: Hero(
                                                            tag: "${name}",
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: fastfood
                                                                      .data()[
                                                                  'image'],
                                                              fit: BoxFit.fill,
                                                              height:
                                                                  width * 0.32,
                                                              width:
                                                                  width * 0.32,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10,
                                                                    top: 10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        text(fastfood.data()[
                                                            'Itemname']),
                                                        // text(mListings[index].address,
                                                        //     maxLine: 1,
                                                        //     textColor: t7textColorSecondary,
                                                        //     fontSize: textSizeSMedium),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            RatingBar(
                                                              initialRating: fastfood
                                                                  .data()[
                                                                      'rating']
                                                                  .toDouble(),
                                                              minRating: 1,
                                                              itemSize: 16,
                                                              direction: Axis
                                                                  .horizontal,
                                                              itemPadding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          1.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {},
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            text(
                                                                fastfood
                                                                        .data()[
                                                                            'reviewcount']
                                                                        .toString() +
                                                                    " reviews",
                                                                textColor: Color(
                                                                    0xFF9D9D9D),
                                                                fontSize: 14.0),
                                                          ],
                                                        ),
                                                        text1(
                                                            "\u{20B9}" +
                                                                fastfood.data()[
                                                                    'amount'],
                                                            textColor: Color(
                                                                0xFF9D9D9D),
                                                            fontSize: 14.0),
                                                        text1(
                                                            fastfood
                                                                    .data()[
                                                                        'description']
                                                                    .substring(
                                                                        0, 50) +
                                                                "...",
                                                            maxLine: 1,
                                                            isLongText: true,
                                                            textColor: Color(
                                                                0xFF9D9D9D),
                                                            fontSize: 14.0),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Divider(
                                                          height: 1,
                                                          color:
                                                              Color(0xFFDADADA),
                                                          thickness: 1,
                                                        )
                                                      ],
                                                    ),
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
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: boxDecoration(showShadow: true, radius: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mHeading("Drinks"),
                            mViewAll(context, "View All",
                                tags: Categories(
                                  category: "Drinks",
                                )),
                          ],
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('All')
                                .where("category", isEqualTo: "Drinks")
                                .limit(4)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'We got an Error ${snapshot.error}');
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
                                  return SizedBox(
                                    height: 240,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      itemCount: snapshot.data.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot drinks =
                                            snapshot.data.docs[index];
                                        print(snapshot.data.docs[index].id);
                                        return Item(
                                          name: drinks.data()['Itemname'],
                                          image: drinks.data()['image'],
                                          price: drinks.data()['amount'],
                                          rating: drinks.data()['rating'],
                                          description:
                                              drinks.data()['description'],
                                          category: drinks.data()['category'],
                                          type: drinks.data()['type'],
                                          inv: drinks.data()['stock'],
                                          docid: drinks.id,
                                          rate1: drinks.data()['rate1'],
                                          rate2: drinks.data()['rate2'],
                                          rate3: drinks.data()['rate3'],
                                          rate4: drinks.data()['rate4'],
                                          rate5: drinks.data()['rate5'],
                                          ratingcount:
                                              drinks.data()['ratingcount'],
                                          reviewcount:
                                              drinks.data()['reviewcount'],
                                        );
                                      },
                                    ),
                                  );
                              }
                            }),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    decoration: boxDecoration(showShadow: true, radius: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        mHeading("Get Inspired By Collections"),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dashlistings.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Collection(dashlistings[index], index);
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    decoration: boxDecoration(showShadow: true, radius: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mHeading("Desserts"),
                            mViewAll(context, "View All",
                                tags: Categories(
                                  category: "Desserts",
                                )),
                          ],
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('All')
                                .where("category", isEqualTo: "Desserts")
                                .limit(4)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'We got an Error ${snapshot.error}');
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
                                  return SizedBox(
                                    height: 240,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      itemCount: snapshot.data.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot drinks =
                                            snapshot.data.docs[index];
                                        print(snapshot.data.docs[index].id);
                                        return Item(
                                          name: drinks.data()['Itemname'],
                                          image: drinks.data()['image'],
                                          price: drinks.data()['amount'],
                                          rating: drinks.data()['rating'],
                                          description:
                                              drinks.data()['description'],
                                          category: drinks.data()['category'],
                                          type: drinks.data()['type'],
                                          inv: drinks.data()['stock'],
                                          docid: drinks.id,
                                          rate1: drinks.data()['rate1'],
                                          rate2: drinks.data()['rate2'],
                                          rate3: drinks.data()['rate3'],
                                          rate4: drinks.data()['rate4'],
                                          rate5: drinks.data()['rate5'],
                                          ratingcount:
                                              drinks.data()['ratingcount'],
                                          reviewcount:
                                              drinks.data()['reviewcount'],
                                        );
                                      },
                                    ),
                                  );
                              }
                            }),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InstaSlider extends StatelessWidget {
  final String img, heading, subheading;

  InstaSlider(
      {Key key,
      @required this.img,
      @required this.heading,
      @required this.subheading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(img, fit: BoxFit.cover)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Flexible(
                    child: text(heading,
                        textColor: Colors.white,
                        fontSize: 24.0,
                        fontFamily: 'Bold',
                        maxLine: 2)),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    text1(subheading,
                        textColor: Colors.white,
                        fontFamily: 'Andina',
                        isLongText: true),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Filter extends StatelessWidget {
  CategoryModel model;

  Filter(CategoryModel model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => model.tags));
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Container(
              decoration: boxDecoration(bgColor: model.color, radius: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  model.img,
                  height: width * 0.12,
                  width: width * 0.12,
                ),
              ),
            ),
            text(model.name, textColor: Color(0xFF757575))
          ],
        ),
      ),
    );
  }
}
