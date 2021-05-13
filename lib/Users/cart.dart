import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/pdfView.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Model/order.dart';
import 'package:canteen_app/Model/recieptorder.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:canteen_app/Users/token.dart';
import 'package:canteen_app/Users/var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:uuid/uuid.dart';

class Cart extends StatefulWidget {
  final int length;
  Cart({this.length});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int amount = 0, ordersize = 0;
  String paymentStatus = "", paymentId = "";
  String docid = "";
  var date = new DateFormat.yMd().format(new DateTime.now());
  var timeHour = TimeOfDay.now().hour;
  var timeMin = TimeOfDay.now().minute;
  var timePeriod = TimeOfDay.now().period.toString();
  String timeset, period;
  bool isLoading = false;
  List<FoodItems> products;
  var uuid = Uuid();
  void setTime() {
    if (timePeriod == "DayPeriod.am") {
      if (timeHour == 0) {
        timeHour = 12;
      }
      period = "AM";
      if (timeMin < 10) {
        timeset =
            timeHour.toString() + ":0" + timeMin.toString() + " " + period;
      } else {
        timeset = timeHour.toString() + ":" + timeMin.toString() + " " + period;
      }
    } else {
      if (timeHour == 12) {
        timeHour = 12;
      } else {
        timeHour = timeHour - 12;
      }

      period = "PM";
      if (timeMin < 10) {
        timeset =
            timeHour.toString() + ":0" + timeMin.toString() + " " + period;
      } else {
        timeset = timeHour.toString() + ":" + timeMin.toString() + " " + period;
      }
    }
  }

  Future<void> createOrders(String amountadd, String orderrange,
      String displaytime, String status, String statusid) async {
    return await FirebaseFirestore.instance.collection("Orders").add({
      "Totalamount": amountadd,
      "time": DateTime.now(),
      "ordertime": orderrange,
      "displaytime": displaytime,
      "status": status,
      "statusid": statusid,
      "uid": FirebaseAuth.instance.currentUser.uid,
      "name": name,
      "image": profileimg,
      "phone": phn
    }).then((value) {
      docid = value.id;
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
          title: Text(
              'Please wait while we place your order\nThis will take some time..'),
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

  //Razorpay payment
  Razorpay _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment successful", timeInSecForIosWeb: 4);
    paymentId = response.paymentId;
    String msg = "Success";
    date = new DateFormat.yMd().format(new DateTime.now());
    timeHour = TimeOfDay.now().hour;
    timeMin = TimeOfDay.now().minute;
    timePeriod = TimeOfDay.now().period.toString();
    await setTime();
    setState(() {
      isLoading = true;
    });
    if (isLoading) {
      loadDialog();
    }
    await createOrders(
        amount.toString(), selectedIndexCategory, timeset, "Online", paymentId);
    for (int i = 0; i < products.length; i++) {
      addOrdersItems(products[i].name, products[i].quantity, products[i].image,
          products[i].amount, docid);
    }
    Future.delayed(const Duration(seconds: 5), () async {
      userNot(msg);
      adminNotOrders();
      adminNotPayment();
      deleteCart();
      setState(() {
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomeView();
        },
      ), (route) => false);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    Fluttertoast.showToast(
        msg: "ERROR:" + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
    userNot("Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  List<String> time = [
    "10:00-11:00",
    "11:00-12:00",
    "12:00-1:00",
    "1:00-2:00",
    "2:00-3:00",
    "3:00-4:00"
  ];
  String selectedIndexCategory;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    amount = 0;
    ordersize = 0;
    products = List<FoodItems>();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amount) async {
    var options = {
      'key': 'rzp_test_ilVZU64kpCLrTf',
      'amount': amount,
      'name': 'InstaFood',
      'description': 'Food Orders',
      'prefill': {'contact': phn, 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
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
                                  Card(
                                    elevation: 4,
                                    child: DropdownButton(
                                      hint: Text("Select Time").paddingLeft(8),
                                      value: selectedIndexCategory,
                                      dropdownColor: Colors.white,
                                      style: boldTextStyle(),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                      underline: 0.height,
                                      items: time.map((value) {
                                        return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                    style: primaryTextStyle())
                                                .paddingLeft(8));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedIndexCategory = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              //openCheckout(40*100);
                              final popup = BeautifulPopup(
                                context: context,
                                template: TemplateGreenRocket,
                              );
                              popup.show(
                                title: "Payment Mode",
                                content: MyStatefulWidget(),
                                actions: [
                                  popup.button(
                                      label: "OK",
                                      onPressed: () async {
                                        if (method == PaymentMethod.payonline) {
                                          openCheckout(amount * 100);
                                          
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Payment done");
                                          paymentId = docid;
                                          String msg = "Success";
                                          date = new DateFormat.yMd()
                                              .format(new DateTime.now());
                                          timeHour = TimeOfDay.now().hour;
                                          timeMin = TimeOfDay.now().minute;
                                          timePeriod =
                                              TimeOfDay.now().period.toString();
                                          await setTime();
                                          String id = uuid.v1();
                                          String tokenid = id.substring(0, 16);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (isLoading) {
                                            loadDialog();
                                          }
                                          await createOrders(
                                              amount.toString(),
                                              selectedIndexCategory,
                                              timeset,
                                              "Token",
                                              tokenid);
                                          for (int i = 0;
                                              i < products.length;
                                              i++) {
                                            addOrdersItems(
                                                products[i].name,
                                                products[i].quantity,
                                                products[i].image,
                                                products[i].amount,
                                                docid);
                                                
                                          }
                                          Future.delayed(
                                              const Duration(seconds: 5),
                                              () async {
                                            adminNotOrders();
                                            deleteCart();
                                            setState(() {
                                              isLoading = false;
                                            });
                                            
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.white,
                                                titlePadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 16),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 16),
                                                title: Text("Order Booked",
                                                    style: boldTextStyle(
                                                        size: 20)),
                                                content: Text(
                                                    "OrderId: " + tokenid,
                                                    style: primaryTextStyle()),
                                                actions: [
                                                  RaisedButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                        builder: (context) {
                                                          return HomeView();
                                                        },
                                                      ), (route) => false);
                                                    },
                                                    child: Text("Ok"),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                        }
                                      }),
                                ],
                              );
                            },
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
                  amount = 0;
                  ordersize = 0;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot cartList = snapshot.data.docs[index];
                      print(snapshot.data.docs[index].id);
                      amount += int.parse(cartList.data()['amount']);
                      ordersize += 1;
                      if (products.asMap()[index] != null) {
                        products.removeAt(index);
                      }
                      products.insert(
                          index,
                          new FoodItems(
                              cartList.data()['Itemname'],
                              cartList.data()['image'],
                              cartList.data()['amount'].toString(),
                              cartList.data()['quantity'].toString(),
                              cartList.data()['type']));
                      print(products.length);
                      print(products[0].amount + products[0].quantity);
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
                                                cartList.data()['type'] ==
                                                            "veg" ||
                                                        cartList.data()[
                                                                'type'] ==
                                                            null
                                                    ? Image.asset(
                                                        "assets/food_c_type.png",
                                                        color: Colors.green,
                                                        width: 18,
                                                        height: 18)
                                                    : Image.asset(
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
                                                        "\u{20B9}",
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
                                        amount: int.parse(
                                            cartList.data()['amount'])),
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

  Future<void> deleteCart() async {
   FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('cart').snapshots().forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
  }
}

class Quantitybtn extends StatefulWidget {
  final int count, amount;
  final String id;
  Quantitybtn({this.count, this.id, this.amount});

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
      'amount': (((widget.amount / widget.count) * count).round()).toString()
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
      ],
    );
  }
}

enum PaymentMethod { payonline, token }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  PaymentMethod _character = PaymentMethod.payonline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    method = PaymentMethod.payonline;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text(
            'Pay Online',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          leading: Radio<PaymentMethod>(
            value: PaymentMethod.payonline,
            groupValue: _character,
            onChanged: (PaymentMethod value) {
              setState(() {
                _character = value;
                method = _character;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Token',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          leading: Radio<PaymentMethod>(
            value: PaymentMethod.token,
            groupValue: _character,
            onChanged: (PaymentMethod value) {
              setState(() {
                _character = value;
                method = _character;
              });
            },
          ),
        ),
      ],
    );
  }
}

class FoodItems {
  String name, image, amount, quantity, type;

  FoodItems(name, image, amount, quantity, type) {
    this.name = name;
    this.image = image;
    this.amount = amount;
    this.quantity = quantity;
    this.type = type;
  }
}
