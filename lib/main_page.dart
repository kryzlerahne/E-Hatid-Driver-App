import 'package:ehatid_driver_app/accept_decline.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/homepage.dart';
import 'package:ehatid_driver_app/intro_slider.dart';
import 'package:ehatid_driver_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AcceptDecline();
        } else {
          return LoginScreen();
        }
        },
        ),
    );
  }
}
