import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:canteen_app/Admin/addproduct.dart';
import 'package:canteen_app/Helpers/dataGenerator.dart';
import 'package:canteen_app/Helpers/extensions.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Model/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  List<CategoryModel> Listings1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Listings1 = getFilterFavourites();
  }


  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);
    double expandHeight = MediaQuery.of(context).size.height * 0.33;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
            body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandHeight,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              pinned: true,
              titleSpacing: 0,
              backgroundColor: innerBoxIsScrolled ? Color(0xFFffffff) : Color(0xFFffffff),
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
                             IconButton(
                               icon: Icon(Icons.menu, color: Colors.black,size: 25,),
                               onPressed: () {

                               },
                             ),
                          SizedBox(width: 10,),
                          text('Home', textColor: Colors.black, fontSize: 25.0, fontFamily: 'Bold'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,size: 25,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AddProduct()));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications_active,
                              color: Colors.black,size: 25,
                            ),
                            onPressed: () {

                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.black,size: 25,
                            ),
                            onPressed: () {

                            },
                          ),
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
                                img: "assets/home6.jpg",
                                heading: "The variety on your \nplate",
                                subheading: "Where tasteful creations begin.",
                              ),
                              InstaSlider(
                                img: "assets/home2.jpg",
                                heading: "Food that melts your \nheart",
                                subheading: "Where tasteful creations begin.",
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
                        textStyle: TextStyle(fontSize: 20.0, fontFamily: "Bold",color: Colors.green),
                        textAlign: TextAlign.start
                    ),
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
                            padding: const EdgeInsets.only(top: 10,left:20, bottom: 16),
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
                SizedBox(height: 10,),
                //Image.network("https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1083803145453170&height=200&width=200&ext=1618153893&hash=AeSonAU8Oo3ZaDY-f6I"),
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

  InstaSlider({Key key, @required this.img, @required this.heading, @required this.subheading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(width: MediaQuery.of(context).size.width, child: Image.asset(img, fit: BoxFit.cover)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60,),
                text(heading, textColor: Colors.white, fontSize: 24.0, fontFamily: 'Bold', maxLine: 2),
                SizedBox(
                  height: 4,
                ),
                text(subheading, textColor: Colors.white, fontFamily: 'Medium', isLongText: true),
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
    return Container(
      margin: EdgeInsets.only(left: 16),
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
    );
  }
}
