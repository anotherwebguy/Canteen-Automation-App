import 'package:canteen_app/Helpers/orderContainer.dart';
import 'package:canteen_app/Helpers/userhistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MyordersScreen extends StatefulWidget {
  @override
  _MyordersScreenState createState() => _MyordersScreenState();
}

class _MyordersScreenState extends State<MyordersScreen> {
  int selectedindex;

  @override
  void initState() {
    super.initState();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var myOrders = Container(
      color: Color(0xFFf2f2f1),
      padding: EdgeInsets.all(16),
      width: context.width(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Orders")
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                            //padding: EdgeInsets.only(bottom:10),
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              DocumentSnapshot orders =
                                  snapshot.data.docs[index];
                              print(snapshot.data.docs[index].id);
                              return OrderContainer(
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
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                              DocumentSnapshot history =
                                  snapshot.data.docs[index];
                              print(snapshot.data.docs[index].id);
                              return UserHistory(
                                  index: index,
                                  name: history.data()['name'],
                                  image: history.data()['sign'],
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
            title: Text('My Orders',
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
                        'My Orders',
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
        ),
      ),
    );
  }
}
