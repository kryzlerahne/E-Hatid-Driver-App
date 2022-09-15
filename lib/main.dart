import 'package:ehatid_driver_app/Screens/Welcome/welcome_screen.dart';
import 'package:ehatid_driver_app/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Hatid',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Color(0xFFFED90F),
      ),
      home: WelcomeScreen(),
    );
  }
}
