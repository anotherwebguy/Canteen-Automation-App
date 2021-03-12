import 'package:canteen_app/Services/dbdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthService{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageUrl;
  String userName;

  signInWithFacebook() async{
    final result = await FacebookAuth.instance.login();
    final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.token);
    final UserCredential authResult = await _auth.signInWithCredential(facebookAuthCredential);
    final User user = authResult.user;
    final token = facebookAuthCredential.accessToken;
    final graphResponse = await http.get(
    'https://graph.facebook.com/v2.12/me?fields=name,picture.width(200).height(200),first_name,last_name,email&access_token=$token');
    Map userresult;
    final profile = JSON.jsonDecode(graphResponse.body);
    if (user != null) {
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      userName = user.displayName;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      userresult=profile;

      addFacebookUser(user.uid, user.displayName, user.email, userresult["picture"]["data"]["url"]);
      print('signInWithFacebbok succeeded: $user');
      print('Imageurl: ${userresult["picture"]["data"]["url"]}');
      return '${user.uid}';
     }
     return null;
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

      addGoogleUser(user.uid, user.displayName, user.email, user.photoURL);
      print('signInWithGoogle succeeded: $user');

      return '${user.uid}';
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }
}