import 'package:canteen_app/Services/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageUrl;
  String userName;
  bool isExists = false;

  signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);
    final UserCredential authResult =
        await _auth.signInWithCredential(facebookAuthCredential);
    final User user = authResult.user;
    final token = facebookAuthCredential.accessToken;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(200).height(200),first_name,last_name,email&access_token=$token');
    Map userresult;
    final profile = JSON.jsonDecode(graphResponse.body);
    if (user != null) {
      // Checking if email and name is null
      //assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      userName = user.displayName;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      userresult = profile;
      await checkIfUserExist(user.email);
      if (isExists == false) {
        addFacebookUser(user.uid, user.displayName, user.email,
            userresult["picture"]["data"]["url"]);
      }
      print('signInWithFacebbok succeeded: $user');
      print('Imageurl: ${userresult["picture"]["data"]["url"]}');
      return '${user.uid}';
    }
    return null;
  }

  Future<void> signOutFB() async {
    await FacebookAuth.instance.logOut();
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      imageUrl = user.photoURL;
      userName = user.displayName;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      await checkIfUserExist(user.email).then((value) {
        if (isExists == false) {
          addGoogleUser(user.uid, user.displayName, user.email, user.photoURL);
        }
      });

      print('signInWithGoogle succeeded: $user');

      return '${user.uid}';
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }

  Future<String> login(email, pw, BuildContext context) async {
    try {
      UserCredential authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pw);
      final User user = authResult.user;
      if (user != null) {
        return '$user';
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Login Failed'),
                content: Text('Please check the entered details again'),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
    return null;
  }

  Future<String> register(
      String name, String email, String pw, BuildContext context) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pw);
      final User user = authResult.user;
      if (user != null) {
        await addemailuser(user.uid, name, email);
        return '$user';
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Registration Failed'),
                content: Text('User already exists'),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
    return null;
  }

  Future<void> checkIfUserExist(String email) async {
    await FirebaseFirestore.instance
        .collection('admins')
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapShot) {
      if (querySnapShot.size >= 1) {
        querySnapShot.docs.forEach((element) {
          isExists = true;
          print(isExists);
        });
      } else {
        isExists = false;
      }
    });
  }
}
