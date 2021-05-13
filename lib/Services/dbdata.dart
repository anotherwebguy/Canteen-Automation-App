import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String name, email, profileimg, role, phn;
bool existence;
Future<void> addGoogleUser(
    String uid, String name, String email, String profileimg) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).set({
    'username': name,
    'email': email,
    'profileimg': profileimg,
    'role': "user",
  });
}

Future<void> addFacebookUser(
    String uid, String name, String email, String profileimg) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).set({
    'username': name,
    'email': email,
    'profileimg': profileimg,
    'role': "admin",
  });
}

Future<void> addphnandphoto(String uid, String image, String phn) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).update({
    'profileimg': image,
    'phone': phn,
  });
}

Future<void> addemailuser(String uid, String name, String email) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).set({
    'username': name,
    'email': email,
    'profileimg': "",
    'role': "user",
  });
}


Future<void> fetchData() async {
  try {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      name = value.get('username');
      email = value.get('email');
      profileimg = value.get('profileimg');
      role = value.get('role');
      phn = value.get('phone');
      existence = value.exists;
    });
  } catch (e) {}
}

Future<void> addFoodItemAllSection(
    String name,
    String description,
    String amount,
    String path,
    List searchString,
    String type,
    String category, String inv) async {
  return await FirebaseFirestore.instance.collection("All").add({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': category,
    'rating': 0,
    'ratingcount': 0,
    'reviewcount': 0,
    'rate5': 0,
    'rate4': 0,
    'rate3': 0,
    'rate2': 0,
    'rate1': 0,
    'searchString': searchString,
    'type': type,
    'stock':inv
  });
}

Future<void> updateFoodItemAllSection(
    String name,
    String description,
    String amount,
    String path,
    String inv,
    List searchString,
    String type,
    String category,
    String docid) async {
  return await FirebaseFirestore.instance.collection("All").doc(docid).update({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': category,
    'searchString': searchString,
    'type': type,
    'stock':inv
  });
}

Future<void> addFoodItemToCart(String name, String quantity, String amount,
    String type, String path) async {
  return await FirebaseFirestore.instance
      .collection("admins")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("cart")
      .add({
    'Itemname': name,
    'amount': amount,
    'image': path,
    'quantity': quantity,
    'type': type,
  });
}

Future<void> incrementReviewCount(String docid) async {
  return await FirebaseFirestore.instance
      .collection("All")
      .doc(docid)
      .update({"reviewcount": FieldValue.increment(1)});
}

Future<void> incrementRatingCount(String docid) async {
  return await FirebaseFirestore.instance
      .collection("All")
      .doc(docid)
      .update({"ratingcount": FieldValue.increment(1)});
}

Future<void> addReviews(String name, String review, int rating,
    String profileimg, String docid) async {
  return await FirebaseFirestore.instance
      .collection("All")
      .doc(docid)
      .collection("reviews")
      .add({
    "name": name,
    "review": review,
    "rating": rating + 1,
    "image": profileimg,
    "time": DateTime.now()
  });
}

Future<void> addOrdersItems(String name, String quantity, String image,
    String amount, String docid) async {
  return await FirebaseFirestore.instance
      .collection("Orders")
      .doc(docid)
      .collection("cart")
      .add({
    "name": name,
    "quantity": quantity,
    "image": image,
    "amount": amount,
  });
}

Future<void> adminNotPayment() async {
  await FirebaseFirestore.instance
      .collection('admins')
      .snapshots()
      .forEach((element) {
    for (QueryDocumentSnapshot snapshot in element.docs) {
      if (snapshot.data()['role'] == "admin") {
        snapshot.reference.collection('notifications').add({
          'title': "Payment Received From " + name,
          'body': "Payment Received Successfully",
          'time': DateTime.now(),
          'type': "payment",
          'existence': true,
          'status':"success",
          'uid': FirebaseAuth.instance.currentUser.uid
        });
      }
    }
  });
}

Future<void> adminNotOrders() async {
  await FirebaseFirestore.instance
      .collection('admins')
      .snapshots()
      .forEach((element) {
    for (QueryDocumentSnapshot snapshot in element.docs) {
      if (snapshot.data()['role'] == "admin") {
        snapshot.reference.collection('notifications').add({
          'title': "Order Received From " + name,
          'body': "Have a look at this order!!",
          'time': DateTime.now(),
          'type': "orders",
          'existence': true,
          'uid': FirebaseAuth.instance.currentUser.uid
        });
      }
    }
  });
}

Future<void> userNot(String msg) async {
  String title, body, status;
  if (msg == "Success") {
    title = "Payment Successful";
    body = "Payment made successfully";
    status = "Success";
  } else {
    title = "Payment Failed";
    body = "Payment Failed!!!";
    status = "Fail";
  }
  await FirebaseFirestore.instance
      .collection('admins')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('notifications')
      .add({
    'title': title,
    'body': body,
    'existence': true,
    'type': "Payment",
    'time': DateTime.now(),
    'status': status
  });
}

Future<void> updateNotification(String id) async {
  await FirebaseFirestore.instance
      .collection('admins')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("notifications")
      .doc(id)
      .update({
    'existence': false,
  });
}

Future<void> adminNotDelivery(String uid,String docid) async {
  await FirebaseFirestore.instance
      .collection('admins')
      .doc(uid)
      .collection('notifications')
      .add({
    'title': "Order Delivered",
    'body': "Please sign for confirmation",
    'existence': true,
    'type': "Payment",
    'time': DateTime.now(),
    'status': "Sign",
    'docid': docid
  });
}