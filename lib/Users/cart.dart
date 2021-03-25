import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cart extends StatefulWidget {
  final int length;
  Cart({this.length});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<cartItems> products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = List<cartItems>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('cart')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('We got an Error ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
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
            );

          case ConnectionState.none:
            return Scaffold(
              body: Center(
                child: Container(
                  child: Text(
                    "Something returned null",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );

          case ConnectionState.done:
            return Scaffold(
              body: Center(
                child: Container(
                  child: Text(
                    "we are done",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );

          default:
            return Scaffold(
              body: SafeArea(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 20, 0),
                      child: CustomAppBar(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(35, 0, 25, 0),
                      child: title(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 5.0),
                      child: Divider(
                        height: 5,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.length > 0
                          ? foodItemList()
                          : noItemContainer(),
                    )
                  ],
                ),
              )),
              bottomNavigationBar: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: boxDecoration4(
                          showShadow: true,
                          radius: 0,
                          bgColor: Color(0xFFffffff)),
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
                                  text("Tap to view details",
                                      fontFamily: "Medium", fontSize: 18.0),
                                ],
                              ),
                              //text("View Bill Details", textColor: Color(0xFF3B8BEA)),
                              GestureDetector(
                                  onTap: () {
                                    print(products);
                                    showModalBottomSheet<void>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 300,
                                          // color: Colors.white,
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              20.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              20.0))),
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
                                                        top: kDefaultPaddin /
                                                            4), //top padding 5
                                                    height: 4,
                                                    width: 60,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Items: ",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Regular",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          for (var i
                                                              in products)
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  i.title
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                SizedBox(
                                                                  height: 3,
                                                                )
                                                              ],
                                                            ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          //Text("Total: ",style: TextStyle(fontSize: 20,fontFamily: "Regular",fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Quantities: ",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Regular",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          for (var i
                                                              in products)
                                                            Column(
                                                              children: [
                                                                Text( "x "+                                                              
                                                                      i.quantity
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                SizedBox(
                                                                  height: 3,
                                                                )
                                                              ],
                                                            ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          //Text(cartTotal,style: TextStyle(fontSize: 20,fontFamily: "Regular",fontWeight: FontWeight.bold),),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "View Bill Details",
                                    style: TextStyle(
                                        color: Color(0xFF3B8BEA),
                                        fontSize: 18.0,
                                        fontFamily: "Regular",
                                        letterSpacing: 0.5,
                                        height: 1.5,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                              decoration: gradientBoxDecoration(
                                  radius: 50,
                                  showShadow: true,
                                  gradientColor1: Colors.green[800],
                                  gradientColor2: Colors.green[300]),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Order",
                                        style: TextStyle(
                                            fontFamily: "Medium",
                                            fontSize: 16.0,
                                            color: Color(0xFFffffff))),
                                    WidgetSpan(
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.fastfood,
                                              color: Color(0xFFffffff),
                                              size: 18)),
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
              ),
            );
        }
      },
    );
  }

  Container noItemContainer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Text(
              "No More Items Left In The Cart",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget foodItemList() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('admins')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('cart')
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
                  return Text(
                    "Something returned null",
                    style: TextStyle(color: Colors.black),
                  );

                case ConnectionState.done:
                  return Text(
                    "we are done",
                    style: TextStyle(color: Colors.black),
                  );

                default:
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot cartList = snapshot.data.docs[index];
                      print(snapshot.data.docs[index].id);
                      if (products.asMap()[index] != null) {
                        products.removeAt(index);
                      }
                      products.insert(
                          index,
                          new cartItems(
                              cartList.data()['Itemname'],
                              int.parse(cartList.data()['quantity']),
                              int.parse(cartList.data()['amount'])));
                      print(products.length);
                      return Slidable(
                        key: ValueKey(index),
                        actionPane: SlidableDrawerActionPane(),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          cartList.data()['image'],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            text(
                                                "x" +
                                                    cartList
                                                        .data()['quantity']
                                                        .toString() +
                                                    " " +
                                                    cartList.data()['Itemname'],
                                                fontFamily: "Medium",
                                                textColor: Colors.black),
                                            Row(
                                              children: [
                                              cartList.data()['type']=="veg" || cartList.data()['type']==null?
                                                Image.asset(
                                                    "assets/food_c_type.png",
                                                    color: Colors.green,
                                                    width: 18,
                                                    height: 18) :
                                                    Image.asset(
                                                    "assets/food_c_type.png",
                                                    color: Colors.red,
                                                    width: 18,
                                                    height: 18),
                                                text("   Amount: "),
                                                text(
                                                    cartList
                                                            .data()['amount']
                                                            .toString() +
                                                        " " +
                                                        "Rs",
                                                    textColor: Colors.green),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Quantitybtn(
                                        count: int.parse(
                                            cartList.data()['quantity']),
                                        id: cartList.id,
                                        amount: int.parse(cartList.data()['amount'])),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Delete',
                            color: Color(0xFFE15858),
                            icon: Icons.delete_outline,
                            onTap: () {
                              deleteItem(cartList.id);
                            },
                          ),
                        ],
                      );
                    },
                  );
              }
            },
          )
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "My",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
              Text(
                "CartList",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .doc(id)
        .delete();
  }

  // String share() {
  //   String val = "";
  //   for (var i in products) {
  //     val += i.title.toString() +
  //         ": \t\t\t " +
  //         i.quantity.toString() +
  //         i.unit.toString() +
  //         "\n";
  //   }
  //   return val;
  // }

  // void calcTotal(){
  //   int total=0;
  //   for(var i in products){
  //     total+=i.quantity;
  //   }
  //   cartTotal=total.toString();
  // }

  String calcnewTotal() {
    Future.delayed(const Duration(seconds: 10), () {});
    int total = 0;
    for (var i in products) {
      total += i.quantity;
    }
    return total.toString();
  }

  Future<void> deleteCart() async {
    FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .snapshots()
        .forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
  }
}

class Quantitybtn extends StatefulWidget {
  final int count,amount;
  final String id;
  Quantitybtn({this.count, this.id,this.amount});

  @override
  QuantitybtnState createState() => QuantitybtnState();
}

class QuantitybtnState extends State<Quantitybtn> {
  bool visibility = false;

  var countstore = 1;

  void _changed() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      countstore = widget.count;
    });
  }

  Future<void> _updateCart(int count) async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart')
        .doc(widget.id)
        .update({
          'quantity': count.toString(),
          'amount': (((widget.amount/widget.count)*count).round()).toString()
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: visibility,
      child: Container(
        height: width * 0.08,
        alignment: Alignment.center,
        width: width * 0.23,
        //decoration: boxDecoration4(color: Colors.black, radius: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: width * 0.08,
              height: width * 0.08,
              decoration: BoxDecoration(
                  color: Color(0xFF333333),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      topLeft: Radius.circular(4.0))),
              child: IconButton(
                icon: Icon(Icons.remove, color: Color(0xFFffffff), size: 10),
                onPressed: () {
                  setState(() {
                    if (countstore == 1 || countstore < 1) {
                      countstore = 1;
                    } else {
                      countstore = countstore - 1;
                    }
                  });
                  _updateCart(countstore);
                },
              ),
            ),
            text("$countstore"),
            Container(
              width: width * 0.08,
              height: width * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFF333333),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4.0),
                      topRight: Radius.circular(4.0))),
              child: IconButton(
                icon: Icon(Icons.add, color: Color(0xFFffffff), size: 10),
                onPressed: () {
                  setState(() {
                    countstore = countstore + 1;
                  });
                  _updateCart(countstore);
                },
              ),
            ),
          ],
        ),
      ),
      replacement: GestureDetector(
        onTap: () {
          _changed();
        },
        child: Container(
          width: width * 0.22,
          height: width * 0.08,
          //decoration: boxDecoration4(color: Color(0xFFffffff), radius: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          alignment: Alignment.center,
          child: text1("ADD", isCentered: true),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        //DragTargetWidget(bloc),
        //Icon(Icons.delete_forever, color: Colors.red,size: 30,)
      ],
    );
  }
}

class cartItems {
  String title;
  int quantity;
  int amount;
  cartItems(title, quantity, unit) {
    this.title = title;
    this.quantity = quantity;
    this.amount = amount;
    print(this.amount);
  }
}
