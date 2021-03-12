import 'package:canteen_app/Services/signin.dart';
import 'package:canteen_app/homeView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
                Buttons.Google,
                onPressed: ()async {
                  await _auth.signInWithGoogle().then(
                        (result) async {
                      if (result != null) {
                        //await fetchModuleList();
                        await FirebaseFirestore.instance.collection("admins").
                        doc(FirebaseAuth.instance.currentUser.uid)
                            .get()
                            .then((value) =>
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeView();
                                  },
                                ), (route) => false)
                        );
                      }
                    },
                  );
                }
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              Buttons.Facebook, 
              onPressed: () async{
                await _auth.signInWithFacebook().then(
                        (result) async {
                      if (result != null) {
                        //await fetchModuleList();
                        await FirebaseFirestore.instance.collection("admins").
                        doc(FirebaseAuth.instance.currentUser.uid)
                            .get()
                            .then((value) =>
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeView();
                                  },
                                ), (route) => false)
                        );
              }});
              })
          ],
        ),
      ),
    );
  }
}
