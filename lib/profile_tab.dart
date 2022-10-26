import 'dart:async';

import 'package:ehatid_driver_app/global.dart';
import 'package:ehatid_driver_app/info_design_ui.dart';
import 'package:ehatid_driver_app/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';


class ProfileTabPage extends StatefulWidget
{
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage>
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c)
          {
            return ProgressDialog(message: "Signing Out, Please wait...",);
          }
      );
      Timer(const Duration(seconds: 2),(){
        Fluttertoast.showToast(msg: "Signed Out Successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (c)=>  LoginScreen()));
      });
    } catch (e) {
      print(e.toString()) ;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [

            Positioned(
              top: 0,
              child: Image.asset("assets/images/Vector 3.png",
                width: size.width,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //logo
                Image.asset("assets/images/ehatid logo.png",
                  width: Adaptive.h(25),
                ),

                SizedBox(height: 3.h),

                //name
                Text(
                  onlineDriverData.first_name!.toString() + onlineDriverData.last_name!.toString(),
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                Text(
                  titleStarsRating + " Driver",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 20,
                    color: Color(0xFF0CBC8B),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 4.h,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                    height: 2,
                    thickness: 2,
                  ),
                ),

                SizedBox(height: 5.h),

                //phone
                InfoDesignUIWidget(
                  textInfo: onlineDriverData.phone!,
                  iconData: Icons.phone_iphone,
                ),

                //email
                InfoDesignUIWidget(
                  textInfo: onlineDriverData.email!,
                  iconData: Icons.email,
                ),

                //plate number
                InfoDesignUIWidget(
                  textInfo: onlineDriverData.plateNum!,
                  iconData: Icons.pin_outlined,
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  onPressed: () async => await _signOut(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
