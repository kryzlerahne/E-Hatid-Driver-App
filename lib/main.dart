import 'package:ehatid_driver_app/Screens/login.dart';
import 'package:ehatid_driver_app/main_page.dart';
import 'package:flutter/material.dart';
import 'intro_slider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color(0xFFFED90F),
      ),
      home: IntroSliderPage(),
    );
  }
}


