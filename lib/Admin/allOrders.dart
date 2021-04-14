import 'package:barcode_scan/barcode_scan.dart';
import 'package:canteen_app/Helpers/orderContainer.dart';
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

  @override
  void initState() {
    super.initState();
    barcode = "";
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
                                  final popup = BeautifulPopup(
                                    context: context,
                                    template: TemplateGreenRocket,
                                  );
                                  popup.show(
                                    title: "Order Delivered?",
                                    content: Center(
                                      child: Container(
                                        child: Text(
                                            "Note: Only proceed if you have delivered the food to the owner"),
                                      ),
                                    ),
                                    actions: [
                                      popup.button(
                                          label: "Delivered?",
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              isLoading = true;
                                            });
                                            if (isLoading) {
                                              loadDialog();
                                            }
                                            await addtoHistory(
                                                orders.data()['name'],
                                                orders.data()['image'],
                                                orders.data()['Totalamount'],
                                                orders.data()['phone'],
                                                orders.data()['status'],
                                                orders.data()['statusid'],
                                                orders.data()['ordertime'],
                                                orders.data()['uid']);
                                            Future.delayed(
                                                const Duration(seconds: 5),
                                                () async {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              adminNotDelivery(
                                                  orders.data()['uid'], docid);
                                              await FirebaseFirestore.instance
                                                  .collection('Orders')
                                                  .doc(orders.id)
                                                  .delete();
                                            });
                                          }),
                                    ],
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
      alignment: Alignment.center,
      width: context.width(),
      child: Column(
        children: [
          Text(
            'Home',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          15.height,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          )
        ],
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
