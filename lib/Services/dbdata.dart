import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String name, email, profileimg,role,phn;
bool existence;


Future<void> addGoogleUser(String uid, String name, String email, String profileimg) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).set({
    'username': name,
    'email': email,
    'profileimg': profileimg,
    'role': "user",
  });
}

Future<void> addFacebookUser(String uid, String name, String email, String profileimg) async {
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
      role=value.get('role');
      phn=value.get('phone');
      existence=value.exists;
    });
  } catch (e) {}
}

Future<void> addFoodItemCategoryWise(String category, String name, String description, String amount, String path, List searchString, String type) async {
  return await FirebaseFirestore.instance.collection(category).add({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': category,
    'rating': 0,
    'searchString': searchString,
    'type':type
  });
}

Future<void> addFoodItemAllSection(String name, String description, String amount, String path, List searchString, String type) async {
  return await FirebaseFirestore.instance.collection("All").add({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': "All",
    'rating': 0,
    'searchString': searchString,
    'type':type
  });
}

Future<void> addFoodItemToCart(String name, String quantity, String amount, String type, String path) async {
  return await FirebaseFirestore.instance.collection("admins").doc(FirebaseAuth.instance.currentUser.uid).collection("cart").add({
    'Itemname': name,
    'amount': amount,
    'image': path,
    'quantity': quantity,
    'type': type,
  });
}
