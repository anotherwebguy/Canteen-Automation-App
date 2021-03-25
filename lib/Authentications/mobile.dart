import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/extensions.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class Mobile extends StatefulWidget {

  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {

  File img1;
  String path1="";
  TextEditingController phone = new TextEditingController();

  Future getProfileImage() async {
    final pickedFile = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        path1 = pickedFile.path;
        img1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadProfileImg() async {

    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'admins/${FirebaseAuth.instance.currentUser.uid}/images/${Path.basename(img1.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(img1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURLTwo) {
      setState(() {
        path1 = fileURLTwo;
        print(path1);
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.white);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mTop(context, "Phone Verification"),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: spacing_large),
                        Center(child: text1("Welcome", fontFamily: 'Medium', fontSize: 30.0)),
                        SizedBox(height: spacing_middle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Profile picture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Ink(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(65.0),
                                ),
                              ),
                              child: img1 == null && profileimg==""
                                  ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(65.0),
                                  ),
                                ),
                                onPressed: getProfileImage,
                                color: Colors.grey[200],
                                child: CachedNetworkImage(imageUrl: 'https://cdn.onlinewebfonts.com/svg/img_133373.png',fit: BoxFit.fill,),
                              )
                                  : profileimg!=""? 
                                  GestureDetector(
                               // onTap: getProfileImage,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(65.0),
                                  ),
                                  child: Image.network(
                                    profileimg,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ): GestureDetector(
                                onTap: getProfileImage,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(65.0),
                                  ),
                                  child: Image.file(
                                    img1,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        profileimg ==""?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Tap to choose profile image")
                          ],
                        ):Text(""),
                        text("Enter your phone number to continue to InstaFood and manage canteen orders at the tip of your fingers.",textColor: Color(0xFF9D9D9D), isLongText: true, isCentered: true),
                        SizedBox(height: spacing_large),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: mobile(showShadow: false, bgColor: Color(0xFFCCFFFFFF), radius: 8, color: Color(0xFFDADADA)),
                              padding: EdgeInsets.all(0),
                              child: text1(" IN +91 ",fontSize: 20.0),
                            ),
                            SizedBox(width: spacing_standard_new),
                            Expanded(
                              child: Container(
                                decoration: mobile(showShadow: false, bgColor: Color(0xFFCCFFFFFF), radius: 8, color: Color(0xFFDADADA)),
                                padding: EdgeInsets.all(0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  style: TextStyle(fontSize: textSizeLargeMedium, fontFamily: 'Regular'),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                                    hintText: 'Enter mobile number',
                                    prefixIcon: Icon(Icons.call),
                                    hintStyle: TextStyle(color: Color(0xFF9D9D9D), fontSize: textSizeMedium),
                                    border: InputBorder.none,
                                  ),
                                  controller:phone,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: spacing_large),
                        AppButton(
                          onPressed: () async{
                            if(profileimg!=null){
                              await addphnandphoto(FirebaseAuth.instance.currentUser.uid, profileimg, phone.text);
                              await fetchData();
                            Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeView();
                                    },
                                  ), (route) => false);

                            } else {
                              await uploadProfileImg();
                              await addphnandphoto(FirebaseAuth.instance.currentUser.uid, path1, phone.text);
                              await fetchData();
                            Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomeView();
                                    },
                                  ), (route) => false);
                            }
                           
                          },
                          textContent: "Continue",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}

class AppButton extends StatefulWidget {
  var textContent;
  VoidCallback onPressed;

  AppButton({@required this.textContent, @required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return AppButtonState();
  }
}

class AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: widget.onPressed,
      textColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Color(0xFF494FFB)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: widget.textContent, style: TextStyle(fontSize: textSizeMedium)),
                  WidgetSpan(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.arrow_forward, color: Colors.white, size: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
