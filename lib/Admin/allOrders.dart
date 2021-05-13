import 'package:barcode_scan/barcode_scan.dart';
import 'package:canteen_app/Helpers/adminhistory.dart';
import 'package:canteen_app/Helpers/orderContainer.dart';
import 'package:canteen_app/Helpers/recieptgenerator.dart';
import 'package:canteen_app/Model/recieptorder.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:nb_utils/nb_utils.dart';

class AllOrdersScreen extends StatefulWidget {
  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  int selectedindex;
  String barcode = "";
  bool isLoading = false;
  String docid;
  int base_income = 500;
  int jan = 0,
      feb = 0,
      march = 0,
      april = 0,
      may = 0,
      jun = 0,
      jul = 0,
      aug = 0,
      sep = 0,
      oct = 0,
      nov = 0,
      dec = 0,
      count = 0;
  DateTime nw = DateTime.now();
  var year, monthend, monthstart = 1;
  List<Orders> orderslist = List<Orders>();

  @override
  void initState() {
    super.initState();
    barcode = "";
    year = nw.year;
    monthend = nw.month;
  }

  Future<void> getSales() async {
    setState(() {
      jan = 0;
      feb = 0;
      march = 0;
      april = 0;
      may = 0;
      jun = 0;
      jul = 0;
      aug = 0;
      sep = 0;
      oct = 0;
      nov = 0;
      dec = 0;
    });
    await FirebaseFirestore.instance
        .collection('History')
        .snapshots()
        .forEach((element) {
      if (element.docs.length > 0) {
        element.docs.forEach((queryelement) {
          DateTime inputdata = queryelement.data()['time'].toDate();
          print(inputdata);
          var inputyear = inputdata.year;
          var inputmonth = inputdata.month;
          if (inputyear.compareTo(year) == 0 &&
              inputmonth.compareTo(monthstart) >= 0 &&
              inputmonth.compareTo(monthend) <= 0) {
            count++;
            print("yes");
            setState(() {
              if (inputmonth == 1) {
                jan += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 2) {
                feb += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 3) {
                march += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 4) {
                april += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 5) {
                may += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 6) {
                jun += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 7) {
                jul += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 8) {
                aug += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 9) {
                sep += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 10) {
                oct += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 11) {
                nov += int.parse(queryelement.data()['amount']);
              } else if (inputmonth == 12) {
                dec += int.parse(queryelement.data()['amount']);
              }
            });
          }
        });
      }
    });
  }

  Future<void> setlist() async {
    print(jan.toString() +
        feb.toString() +
        march.toString() +
        april.toString() +
        may.toString());
    var item1 = Orders();
    item1.month = "January";
    item1.amount = jan.toString();
    var per1 = (jan * 100) / base_income;
    if (jan == 0) {
      item1.profit = "0";
      item1.loss = "0";
    } else if (per1 >= 100) {
      item1.profit = (per1 - 100).toString();
      item1.loss = "0";
    } else {
      item1.profit = "0";
      item1.loss = (100 - per1).toString();
    }
      print(item1.amount+item1.loss+item1.month+item1.profit);
      orderslist.add(item1);

    var item2 = Orders();
    item2.month = "February";
    item2.amount = feb.toString();
    var per2 = (feb * 100) / base_income;
    if (feb == 0) {
      item2.profit = "0";
      item2.loss = "0";
    } else if (per2 >= 100) {
      item2.profit = (per2 - 100).toString();
      item2.loss = "0";
    } else {
      item2.profit = "0";
      item2.loss = (100 - per2).toString();
    }
    orderslist.add(item2);

    var item3 = Orders();
    item3.month = "March";
    item3.amount = march.toString();
    var per3 = (march * 100) / base_income;
    if (march == 0) {
      item3.profit = "0";
      item3.loss = "0";
    } else if (per3 >= 100) {
      item3.profit = (per3 - 100).toString();
      item3.loss = "0";
    } else {
      item3.profit = "0";
      item3.loss = (100 - per3).toString();
    }
      orderslist.add(item3);

    var item4 = Orders();
    item4.month = "April";
    item4.amount = april.toString();
    var per4 = (april * 100) / base_income;
    if (april == 0) {
      item4.profit = "0";
      item4.loss = "0";
    } else if (per4 >= 100) {
      item4.profit = (per4 - 100).toString();
      item4.loss = "0";
    } else {
      item4.profit = "0";
      item4.loss = (100 - per4).toString();
    }
      orderslist.add(item4);
    ////ider se kaam krna kal
    ///
    var item5 = Orders();
    item5.month = "May";
    item5.amount = may.toString();
    var per5 = (may * 100) / base_income;
    if (may == 0) {
      item5.profit = "0";
      item5.loss = "0";
    } else if (per5 >= 100) {
      item5.profit = (per5 - 100).toString();
      item5.loss = "0";
    } else {
      item5.profit = "0";
      item5.loss = (100 - per5).toString();
    }
      orderslist.add(item5);
    var item6 = Orders();
    item6.month = "June";
    item6.amount = jun.toString();
    var per6 = (jun * 100) / base_income;
    if (jun == 0) {
      item6.profit = "0";
      item6.loss = "0";
    } else if (per6 >= 100) {
      item6.profit = (per6 - 100).toString();
      item6.loss = "0";
    } else {
      item6.profit = "0";
      item6.loss = (100 - per6).toString();
    }
      orderslist.add(item6);

    var item7 = Orders();
    item7.month = "Jully";
    item7.amount = jul.toString();
    var per7 = (jul * 100) / base_income;
    if (jul == 0) {
      item7.profit = "0";
      item7.loss = "0";
    } else if (per7 >= 100) {
      item7.profit = (per7 - 100).toString();
      item7.loss = "0";
    } else {
      item7.profit = "0";
      item7.loss = (100 - per7).toString();
    }
      orderslist.add(item7);

    var item8 = Orders();
    item8.month = "August";
    item8.amount = aug.toString();
    var per8 = (aug * 100) / base_income;
    if (aug == 0) {
      item8.profit = "0";
      item8.loss = "0";
    } else if (per8 >= 100) {
      item8.profit = (per8 - 100).toString();
      item8.loss = "0";
    } else {
      item8.profit = "0";
      item8.loss = (100 - per8).toString();
    }
      orderslist.add(item8);

    var item9 = Orders();
    item9.month = "September";
    item9.amount = sep.toString();
    var per9 = (sep * 100) / base_income;
    if (sep == 0) {
      item9.profit = "0";
      item9.loss = "0";
    } else if (per9 >= 100) {
      item9.profit = (per9 - 100).toString();
      item9.loss = "0";
    } else {
      item9.profit = "0";
      item9.loss = (100 - per9).toString();
    }
      orderslist.add(item9);

    var item10 = Orders();
    item10.month = "October";
    item10.amount = oct.toString();
    var per10 = (oct * 100) / base_income;
    if (oct == 0) {
      item10.profit = "0";
      item10.loss = "0";
    } else if (per10 >= 100) {
      item10.profit = (per10 - 100).toString();
      item10.loss = "0";
    } else {
      item10.profit = "0";
      item10.loss = (100 - per10).toString();
    }
      orderslist.add(item10);

    var item11 = Orders();
    item11.month = "November";
    item11.amount = nov.toString();
    var per11 = (nov * 100) / base_income;
    if (nov == 0) {
      item11.profit = "0";
      item11.loss = "0";
    } else if (per11 >= 100) {
      item11.profit = (per11 - 100).toString();
      item11.loss = "0";
    } else {
      item11.profit = "0";
      item11.loss = (100 - per11).toString();
    }
      orderslist.add(item11);

    var item12 = Orders();
    item12.month = "December";
    item12.amount = dec.toString();
    var per12 = (dec * 100) / base_income;
    if (dec == 0) {
      item12.profit = "0";
      item12.loss = "0";
    } else if (per12 >= 100) {
      item12.profit = (per12 - 100).toString();
      item12.loss = "0";
    } else {
      item12.profit = "0";
      item12.loss = (100 - per12).toString();
    }
      orderslist.add(item12);
    print(orderslist.length);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void loadingSnackBarAndMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const CircularProgressIndicator(),
        ],
      ),
      duration: const Duration(seconds: 7),
    ));
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future barcodeScanning() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode.toString());
      print(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = '';
        });
      } else {
        setState(() => this.barcode = '');
      }
    } on FormatException {
      setState(() => this.barcode = '');
      Navigator.pop(context);
    } catch (e) {
      setState(() => this.barcode = '');
    }
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
          title: Text('Please wait while we save the info..'),
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

  Future<void> addtoHistory(
      String name,
      String photo,
      String amount,
      String phone,
      String status,
      String statusid,
      String time,
      String uid) async {
    await FirebaseFirestore.instance.collection('History').add({
      'name': name,
      'photo': photo,
      'amount': amount,
      'phone': phone,
      'status': status,
      'statusid': statusid,
      'ordertime': time,
      'uid': uid,
      'time': DateTime.now(),
      'sign': "https://static.thenounproject.com/png/504708-200.png"
    }).then((value) {
      docid = value.id;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var myOrders = Container(
      color: Color(0xFFf2f2f1),
      padding: EdgeInsets.all(16),
      //alignment: Alignment.center,
      width: context.width(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
                stream: (barcode == null || barcode == "")
                    ? FirebaseFirestore.instance
                        .collection("Orders")
                        .orderBy('time', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("Orders")
                        .where('statusid', isEqualTo: barcode)
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
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            //padding: EdgeInsets.only(bottom:10),
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot orders =
                                  snapshot.data.docs[index];
                              print(snapshot.data.docs[index].id);
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      titlePadding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 16),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 16),
                                      title: Text("Order Delivered?",
                                          style: boldTextStyle(size: 20)),
                                      content: Text(
                                          "Note: Only proceed if you have delivered the food to the owner",
                                          style: primaryTextStyle()),
                                      actions: [
                                        RaisedButton(
                                          color: Colors.blue,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            loadingSnackBarAndMessage(
                                                'Confirming Order...');
                                            await addtoHistory(
                                                orders.data()['name'],
                                                orders.data()['image'],
                                                orders.data()['Totalamount'],
                                                orders.data()['phone'],
                                                orders.data()['status'],
                                                orders.data()['statusid'],
                                                orders.data()['ordertime'],
                                                orders.data()['uid']);
                                            adminNotDelivery(
                                                orders.data()['uid'], docid);
                                            await FirebaseFirestore.instance
                                                .collection('Orders')
                                                .doc(orders.id)
                                                .delete();
                                            hideSnackBar();
                                          },
                                          child: Text("Proceed.."),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: OrderContainer(
                                  index: index,
                                  name: orders.data()['name'],
                                  image: orders.data()['image'],
                                  phone: orders.data()['phone'],
                                  totalamount: orders.data()['Totalamount'],
                                  status: orders.data()['status'],
                                  statusid: orders.data()['statusid'],
                                  ordertime: orders.data()['ordertime'],
                                  time: DateTime.parse(orders
                                          .data()['time']
                                          .toDate()
                                          .toString())
                                      .toString(),
                                  docid: orders.id,
                                ),
                              );
                            }),
                      );
                  }
                }),
          ],
        ),
      ),
    );

    var history = Container(
      color: Color(0xFFf2f2f1),
      padding: EdgeInsets.all(16),
      width: context.width(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("History")
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
                      return Container(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot history =
                                  snapshot.data.docs[index];
                              print(snapshot.data.docs[index].id);
                              print(snapshot.data.docs.length);
                              return AdminHistory(
                                  index: index,
                                  name: history.data()['name'],
                                  image: history.data()['photo'],
                                  sign: history.data()['sign'],
                                  phone: history.data()['phone'],
                                  totalamount: history.data()['amount'],
                                  status: history.data()['status'],
                                  statusid: history.data()['statusid'],
                                  ordertime: history.data()['ordertime'],
                                  time: DateTime.parse(history
                                          .data()['time']
                                          .toDate()
                                          .toString())
                                      .toString());
                            }),
                      );
                  }
                }),
          ],
        ),
      ),
    );

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('All Orders',
                style: boldTextStyle(color: Colors.black, size: 20)),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.inventory,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () async {
                  loadingSnackBarAndMessage('Generating Sales-Report...');
                  getSales();
                  Future.delayed(const Duration(seconds: 5), () async {
                    await setlist();
                    hideSnackBar();
                    print(orderslist.length.toString() + "yehi hai");
                    await recieptView(context, orderslist);
                  });
                },
              ),
            ],
            bottom: TabBar(
              onTap: (index) {
                print(index);
                selectedindex = index;
              },
              labelStyle: primaryTextStyle(),
              indicatorColor: Colors.orange,
              physics: BouncingScrollPhysics(),
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.black38,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.article,
                        color: Colors.black38,
                      ),
                      5.width,
                      Text(
                        'All Orders',
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history,
                        color: Colors.black38,
                      ),
                      5.width,
                      Text(
                        'History',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [myOrders, history],
          ),
          floatingActionButton: role == "admin"
              ? FloatingActionButton(
                  onPressed: barcodeScanning,
                  tooltip: "Click to scan barcode",
                  child: Icon(Icons.qr_code),
                  backgroundColor: Colors.orange,
                )
              : SizedBox(width: 0),
        ),
      ),
    );
  }
}
