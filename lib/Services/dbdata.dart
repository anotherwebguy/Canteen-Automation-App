import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String name, email, profileimg;
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
    'role': "user",
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
      existence=value.exists;
    });
  } catch (e) {}
}

Future<void> addFoodItemCategoryWise(String category, String name, String description, String amount, String path, List searchString) async {
  return await FirebaseFirestore.instance.collection(category).add({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': category,
    'rating': 0,
    'searchString': searchString,
  });
}

Future<void> addFoodItemAllSection(String name, String description, String amount, String path, List searchString) async {
  return await FirebaseFirestore.instance.collection("All").add({
    'Itemname': name,
    'description': description,
    'amount': amount,
    'image': path,
    'category': "All",
    'rating': 0,
    'searchString': searchString,
  });
}
