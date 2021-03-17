
import 'package:canteen_app/Services/dbdata.dart';
import 'file:///C:/Users/mohit/AndroidStudioProjects/canteen_app/lib/Authentications/dashboard.dart';
import 'package:canteen_app/homeView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      // home: FirebaseAuth.instance.currentUser != null
      //     ? Database().existence == true
      //     ? ProfileScreen()
      //     : WelcomePage()
      //     : WalkThrough(),

      // home: FirebaseAuth.instance.currentUser != null
      //     ? ProfileScreen()
      //     : WalkThrough(),
     // home: LoginPage(),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeView()
          : Dashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
