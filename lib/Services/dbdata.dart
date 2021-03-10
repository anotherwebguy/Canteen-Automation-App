import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addGoogleUser(String uid, String name, String email, String profileimg) async {
  return await FirebaseFirestore.instance.collection("admins").doc(uid).set({
    'username': name,
    'email': email,
    'profileimg': profileimg,
    'role': "user",
  });
}