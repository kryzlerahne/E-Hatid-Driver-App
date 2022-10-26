import 'dart:async';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ehatid_driver_app/driver_data.dart';
import 'package:ehatid_driver_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
List pList = []; //online-active passengers Information List
List dList= []; //online active drivers info list
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer(); //sound notification
Position? driverCurrentPosition; //position of driver
DriverData onlineDriverData = DriverData();
String titleStarsRating = "Good";
bool isDriverActive = false;
String statusText = "Go Online";
Color buttonColor = Color(0xFF0CBC8B);
