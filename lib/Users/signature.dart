import 'dart:io';
import 'dart:typed_data';

import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as encoder;

class Sign extends StatefulWidget {
  final String docid, notid;

  Sign({this.docid, this.notid});

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  DateTime now = DateTime.now();
  final SignatureController controller =
      SignatureController(penStrokeWidth: 5, penColor: Colors.red);
  String setSignatureURL = "";
  bool isLoading = false;

  Future<void> Save() async {
    await FirebaseFirestore.instance
        .collection('History')
        .doc(widget.docid)
        .update({
      'sign': setSignatureURL,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('notifications')
          .doc(widget.notid)
          .delete();
      setState(() {
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
        ),
        (Route<dynamic> route) => false,
      );
    });
  }

  Future<void> loadDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          title: Text('Please wait while we confirm the order..'),
          actions: <Widget>[
            Center(
              child: Container(
                child: Theme(
                  data: ThemeData.light(),
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getAppBar(context, String title,
      {color = const Color(0XFF8998FF),
      textColor: Colors.white,
      List<Widget> actions}) {
    return AppBar(
      actions: actions,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop()),
      title: text(title, textColor: textColor, fontSize: 18.0),
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: text("Signature Pad", fontSize: 20.0, fontFamily: "Medium"),
        //centerTitle: true,
        // backgroundColor: Colors.transparent,
        //shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Signature(
                controller: controller,
                height: MediaQuery.of(context).size.height,
                backgroundColor: Colors.white10),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 85),
              child: MaterialButton(
                minWidth: 148,
                padding: EdgeInsets.fromLTRB(5, 12, 5, 12),
                color: Color(0XFF8998FF),
                onPressed: () async {
                  try {
                    if (controller.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      if (isLoading) {
                        loadDialog();
                      }
                      var image = await controller.toImage();
                      int height = image.height;
                      int width = image.width;
                      ByteData data = await image.toByteData();
                      Uint8List listData = data.buffer.asUint8List();
                      encoder.Image toEncodeImage =
                          encoder.Image.fromBytes(width, height, listData);
                      encoder.JpegEncoder jpgEncoder = encoder.JpegEncoder();
                      List<int> encodedImage =
                          jpgEncoder.encodeImage(toEncodeImage);

                      final FirebaseStorage storage = FirebaseStorage.instance;
                      final String picture =
                          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                      StorageUploadTask task = storage
                          .ref()
                          .child(picture)
                          .putData(Uint8List.fromList(encodedImage));
                      await task.onComplete.then((value) async {
                        print('File Uploaded');
                        setSignatureURL = await value.ref.getDownloadURL();
                      });
                      Future.delayed(const Duration(seconds: 5), () {
                        Save();
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      });
                    } else {
                      AlertDialog(
                        title: Text(
                          "Please make a Signature First",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: text('Save', textColor: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: MaterialButton(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                color: Color(0XFF8998FF),
                onPressed: () {
                  setState(() {
                    controller.clear();
                  });
                },
                child: text1('Clear Signature', textColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
