import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/constants.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFeedback extends StatefulWidget {
  @override
  _AddFeedbackState createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  var emailCont = TextEditingController();
  var descriptionCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      emailCont.text = phn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: text("Feedback",
            textColor: Colors.black,
            fontSize: textSizeNormal,
            fontFamily: "Medium"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: emailCont,
              enabled: false,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontFamily: "Regular", fontSize: textSizeMedium),
              autofocus: false,
              decoration: formFieldDecoration("contact no."),
            ),
            SizedBox(
              height: spacing_standard_new,
            ),
            TextFormField(
              controller: descriptionCont,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontFamily: "Regular", fontSize: textSizeMedium),
              autofocus: false,
              decoration: formFieldDecoration("Description"),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(40.0)),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("Feedback").add({
                    "contact": emailCont.text,
                    "feedback": descriptionCont.text,
                    "time": DateTime.now(),
                    "name": name
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                },
                color: Color(0xFFf17015),
                child: text1(
                  "Send Feedback",
                  fontFamily: "Medium",
                  fontSize: textSizeLargeMedium,
                  textColor: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
