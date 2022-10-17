import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assistants/assistant_methods.dart';
import 'global/global.dart';
import 'login.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage>
{
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7752, 121.0453),
    zoom: 18.4746,
  );
  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Go Online";
  Color buttonColor = Color(0xFF0CBC8B);
  bool isDriverActive = false;


  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }


  blackThemeGoogleMap()
  {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied)
    {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async
  {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoOrdinates(driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);
  }

  @override
  void initState()
  {
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Color(0xFFFFFCEA)),
      child: Scaffold(
        backgroundColor: Color(0xFFFFFCEA),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Home"),
          backgroundColor: Color(0xFFFED90F),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFFFED90F),
                      ),
                      accountName: new Text('Machu'),
                      accountEmail: new Text(currentFirebaseUser.email!),
                      currentAccountPicture: new CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage("assets/images/machu.jpg"),
                      ),
                    ),
                    ListTile(
                      title: new Text("Account"),
                      onTap: (){},
                      leading: Icon(
                        Icons.account_circle_sharp,
                        color: Color(0xFFFED90F),
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                      ),
                    ),
                    ListTile(
                      title: new Text("FAQ"),
                      onTap: (){},
                      leading: Icon(
                        Icons.question_answer_outlined,
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                      ),
                    ),
                    ListTile(
                      title: new Text("How To Use App"),
                      onTap: (){},
                      leading: Icon(
                        Icons.info_outline_rounded,
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                      ),
                    ),
                    ListTile(
                      title: new Text("Settings"),
                      onTap: (){},
                      leading: Icon(
                        Icons.settings,
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                      ),
                    ),
                    ListTile(
                      title: new Text("Terms & Conditions"),
                      onTap: (){},
                      leading: Icon(
                        Icons.book,
                      ),
                      trailing: Icon(
                        Icons.arrow_right,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Divider(),
                              ListTile(
                                title: Text("Sign Out"),
                                onTap: () async => await _signOut(),
                                leading: Icon(
                                  Icons.logout,
                                ),
                                trailing: Icon(
                                  Icons.arrow_right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller)
              {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                //black theme google map
                // blackThemeGoogleMap();

                locateDriverPosition();
              },
            ),

            //ui for online offline driver
            statusText != "Go Offline"
                ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.black87,
            )
                : Container(),

            //button for online offline driver
            Positioned(
              top: statusText != "Go Offline"
                  ? MediaQuery.of(context).size.height * 0.46
                  : 25,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      if(isDriverActive != true) //offline
                          {
                        driverIsOnlineNow();
                        updateDriversLocationAtRealTime();

                        setState(() {
                          statusText = "Go Offline";
                          isDriverActive = true;
                          buttonColor = Colors.transparent;
                        });

                        //display Toast
                        Fluttertoast.showToast(msg: "You're Now Online");
                      }
                      else //online
                          {
                        driverIsOfflineNow();

                        setState(() {
                          statusText = "Go Online";
                          isDriverActive = false;
                          buttonColor = Color(0xFF0CBC8B);
                        });

                        //display Toast
                        Fluttertoast.showToast(msg: "You're Now Offline");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: statusText != "Go Offline"
                        ? Text(
                      statusText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),),);
  }

  driverIsOnlineNow() async
  {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude
    );

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) { });
  }

  updateDriversLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;

      if(isDriverActive == true)
      {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude
        );
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow()
  {
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
  }
}