import 'package:canteen_app/homeView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Retrieve the device cameras

  } on Exception catch (e) {
    print(e);
  }

  await Firebase.initializeApp();


  runApp(MyApp());
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
      home: HomeView(),

      debugShowCheckedModeBanner: false,
    );
  }
}
