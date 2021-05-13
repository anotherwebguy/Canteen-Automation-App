
import 'package:canteen_app/Authentications/dashboard.dart';
import 'package:canteen_app/Authentications/mobile.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommonScreens/homeView.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Retrieve the device cameras

  } on Exception catch (e) {
    print(e);
  }

  await Firebase.initializeApp();
  await fetchData();


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaFood',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primaryColor: Colors.white,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    
     //Real Login
      home: FirebaseAuth.instance.currentUser != null && phn!=null
          ? HomeView()
          :FirebaseAuth.instance.currentUser != null && phn==null ? Mobile() : Dashboard(),
      debugShowCheckedModeBanner: false,
      );
  }
}
