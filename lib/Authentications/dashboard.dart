import 'package:auth_buttons/res/buttons/facebook_auth_button.dart';
import 'package:auth_buttons/res/buttons/google_auth_button.dart';
import 'package:auth_buttons/res/shared/auth_style.dart';
import 'package:canteen_app/Authentications/mobile.dart';
import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:canteen_app/Services/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AuthService _auth = new AuthService();
  TextEditingController emaillog = new TextEditingController();
  TextEditingController passlog = new TextEditingController();
  TextEditingController emailsignup = new TextEditingController();
  TextEditingController passsignup = new TextEditingController();
  TextEditingController name = new TextEditingController();
  bool _loading = false;

  bottomsheetsign(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return ModalProgressHUD(
            inAsyncCall: _loading,
            color: Colors.black54,
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 5.0,
            ),
            child: Container(
              height: 450,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      children: [
                        SizedBox(width: 25),
                        Text(
                          "Create an account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          "Ease your efforts with us",
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Enter your name",
                              labelText: "NAME",
                              prefixIcon: Icon(
                                Icons.person_outline_sharp,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            controller: name,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Enter your email",
                              labelText: "EMAIL",
                              prefixIcon: Icon(
                                Icons.mail_outline_sharp,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            controller: emailsignup,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: "Enter your password",
                              labelText: "PASSWORD",
                              prefixIcon: Icon(
                                Icons.lock_outline_sharp,
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              suffixIcon: Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            controller: passsignup,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if ((name.text != null || name.text != "") &&
                                  (emailsignup.text != null ||
                                      emailsignup.text != "") &&
                                  (emailsignup.text != null ||
                                      emailsignup.text != "")) {
                                setState(() {
                                  _loading = true;
                                });
                                Navigator.pop(context);
                                await _auth
                                    .register(name.text, emailsignup.text,
                                        passsignup.text, context)
                                    .then(
                                  (result) {
                                    if (result != null) {
                                      Navigator.pop(context);
                                      bottomsheet(context);
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                );
                                setState(() {
                                  _loading = false;
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Incomplete Information'),
                                          content: Text(
                                              'Please Enter All The Details'),
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
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: _loading == false
                                    ? Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already a user?",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    bottomsheet(context);
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bottomsheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return ModalProgressHUD(
            inAsyncCall: _loading,
            color: Colors.black54,
            opacity: 0.7,
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              strokeWidth: 5.0,
            ),
            child: Container(
              height: 490,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Welcome Back!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Sign in to continue",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white70,
                            child: TextFormField(
                              style: TextStyle(color: Colors.grey[700]),
                              decoration: InputDecoration(
                                labelText: "EMAIL",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                hintText: "Enter your email",
                                prefixIcon: Icon(
                                  Icons.mail_outline_sharp,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[700]),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[700])),
                                //border: InputBorder.none,
                              ),
                              controller: emaillog,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            color: Colors.white70,
                            child: TextFormField(
                              style: TextStyle(color: Colors.grey[700]),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "PASSWORD",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.lock_outline_sharp,
                                  color: Colors.black,
                                ),
                                hintText: "Enter your password",
                                suffixIcon: Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[700])),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[700])),
                                //border: InputBorder.none
                              ),
                              controller: passlog,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        if ((emaillog.text != null || emaillog.text != "") &&
                            (passlog.text != null || passlog.text != "")) {
                          setState(() {
                            _loading = true;
                          });
                          Navigator.pop(context);
                          await _auth
                              .login(emaillog.text, passlog.text, context)
                              .then(
                            (result) async {
                              if (result != null) {
                                await fetchData();
                                if (phn == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Mobile()));
                                } else {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return HomeView();
                                    },
                                  ), (route) => false);
                                }
                              }
                            },
                          );
                          setState(() {
                            _loading = false;
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Incomplete Information'),
                                    content:
                                        Text('Please Enter All The Details'),
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
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: _loading == false
                              ? Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                )
                              : CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Divider(
                            color: Colors.grey,
                          )),
                          Text(
                            "Or Connect",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.grey,
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton(
                          Buttons.Google,
                          text: "Sign Up with Google", 
                          onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              Navigator.pop(context);
                              final result = await _auth.signInWithGoogle();
                              if (result != null) {
                                await fetchData();
                                if (phn == null) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Mobile()));
                                } else {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return HomeView();
                                    },
                                  ), (route) => false);
                                }
                              }
                            }
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                            onTap: () {
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                              Navigator.pop(context);
                              bottomsheetsign(context);
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      color: Colors.black54,
      opacity: 0.7,
      progressIndicator: Theme(
        data: ThemeData.dark(),
        child: CupertinoActivityIndicator(
          animating: true,
          radius: 30,
        ),
      ),
      child: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/dash2.jpg",
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width),
                height: (MediaQuery.of(context).size.height),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.only(top: 80),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: text1("InstaFood",
                          textColor: Colors.white,
                          fontSize: 28.0,
                          fontFamily: 'Regular'),
                    ),
                    decoration: boxDecoration2(
                        radius: 12, bgColor: Color(0xFF56303030))),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Color(0xFF56303030)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        text("InstaFood",
                            textColor: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Semibold'),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: text("Where tasteful creations begin.",
                                textColor: Color(0xFF9D9D9D),
                                isLongText: true)),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            bottomsheet(context);
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                              child: text1("Get Started",
                                  textColor: Color(0xFF000000),
                                  isCentered: true,
                                  fontFamily: 'Medium',
                                  textAllCaps: true),
                              decoration: boxDecoration(
                                  bgColor: Colors.white, radius: 6)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
