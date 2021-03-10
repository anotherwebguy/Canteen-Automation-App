import 'package:canteen_app/screens/addproduct.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../homeView.dart';

class LoginPage extends StatelessWidget {
  signInwithGoogle(BuildContext context) async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    if(credential!=null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProduct()));
      print(credential);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    else{
      return Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error occured")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google, 
              onPressed: (){
                signInwithGoogle(context);
                print("Clicked me");
              }
              )
          ],
        ),
      ),
    );
  }
}