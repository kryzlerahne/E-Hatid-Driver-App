import 'package:ehatid_driver_app/homepage.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/order_traking_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_slider.dart';
import 'package:firebase_core/firebase_core.dart';

int initScreen = 0;

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var result = await preferences.getInt('initScreen');
  if(result != null){
    initScreen = result;
  }

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
      //home: IntroSliderPage(),
      initialRoute: initScreen == 0 ? 'introslider' : 'homepage', // paltan ang login ng homepage
      routes: {
        'homepage' : (context) => HomePage(),
        'introslider' : (context) => IntroSliderPage(),
      },
    );
  }
}


