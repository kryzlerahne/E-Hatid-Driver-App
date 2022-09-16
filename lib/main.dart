import 'package:flutter/material.dart';
import 'intro_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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


