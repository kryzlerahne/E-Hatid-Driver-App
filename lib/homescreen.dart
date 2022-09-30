import 'dart:async';
import 'package:ehatid_passenger_app/Screens/Login/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final panelController = PanelController();

  bool _activeButton = true;

  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(23.0525, 72.5667);
  StreamSubscription<loc.LocationData>? locationSubscription;
  
  static const double OnlineGo = 130;
  double GoOnlineHeight = OnlineGo;

  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNavigation();
    addMarker();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('initScreen');
    try {
      await _firebaseAuth.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => SignIn(),
      ),
      );
    } catch (e) {
      print(e.toString()) ;
    }
  }

  void toggle_activeButton() {
    setState(() {
      _activeButton = !_activeButton;
      if (counter == 1) {
        counter - 1;
      } else {
        counter + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paneHeightClosed = MediaQuery.of(context).size.height * 0.19;
    final paneHeightOpen = MediaQuery.of(context).size.height * 0.191;

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
                      accountEmail: new Text(user.email!),
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
        /*floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            toggle_activeButton();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("List of Nearby Passengers",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -1, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "---Passengers---",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, letterSpacing: 2, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("CANCEL"),
                  ),
                ],
              ),
            );
          },
          label: Text(
            _activeButton
                ? 'Go Online'
                : 'Go Offline',
          ),
          backgroundColor: Color(
            _activeButton
                ? 0xFF0CBC8B
                : 0xFFE74338,
          ),
          icon: Icon(Icons.power_settings_new_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              controller: panelController,
              minHeight: paneHeightClosed,
              maxHeight: paneHeightOpen,
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              color: Color(0xFFFED90F),
              onPanelSlide: (position) => setState(() {
                final panelMaxScrollExtent = paneHeightOpen - paneHeightClosed;

                GoOnlineHeight = position * panelMaxScrollExtent + OnlineGo;
              }),
              body: sourcePosition == null
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition: CameraPosition(
                      target: curLocation,
                      zoom: 16,
                    ),
                    markers: {sourcePosition!, destinationPosition!},
                    onTap: (latLng) {
                      print(latLng);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.navigation_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await launchUrl(Uri.parse(
                                  'google.navigation:q=(13.793034, 121.0710068)&key=AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io'));
                            },
                          ),
                        ),
                      ))
                ],
              ),
              panelBuilder: (controller) => PanelWidget(
                controller: controller,
                panelController: panelController,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            Positioned(
              bottom: GoOnlineHeight,
              child: Container(
                height: 30,
                width: 120,
                child: GoOnline(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget GoOnline(BuildContext context) => FloatingActionButton.extended(
    label: Text(
      _activeButton
          ? 'Go Online'
          : 'Go Offline',
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
    ),
    backgroundColor: Color(
      _activeButton
          ? 0xFF0CBC8B
          : 0xFFE74338,
    ),
    onPressed: (){
      toggle_activeButton();
      if (counter == 1){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("List of Nearby Passengers",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -1, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Text(
              "---Passengers---",
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, letterSpacing: 2, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("CANCEL"),
              ),
            ],
          ),
        );
      };
    },
    icon: Icon(Icons.power_settings_new_rounded, size: 17),
  );

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
            controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 16,
            )));
            if (mounted) {
              controller
                  ?.showMarkerInfoWindow(MarkerId(sourcePosition!.markerId.value));
              setState(() {
                curLocation =
                    LatLng(currentLocation.latitude!, currentLocation.longitude!);
                sourcePosition = Marker(
                  markerId: MarkerId(currentLocation.toString()),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
                  infoWindow: InfoWindow(
                      title: '${double.parse(
                          (getDistance(LatLng(13.793034, 121.0710068))
                              .toStringAsFixed(2)))} km'
                  ),
                  onTap: () {
                    print('market tapped');
                  },
                );
              });
              getDirections(LatLng(13.793034, 121.0710068));
            }
          });
    }
  }

  getDirections(LatLng dst) async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCGZt0_a-TM1IKRQOLJCaMJsV0ZXuHl7Io',
        PointLatLng(curLocation.latitude, curLocation.longitude),
        PointLatLng(dst.latitude, dst.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng>polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getDistance(LatLng destposition) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destposition.latitude, destposition.longitude);
  }
  addMarker() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId('source'),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId('destination'),
        position: LatLng(13.793034, 121.0710068),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    controller: controller,
    children: <Widget>[
      SizedBox(height: 5),
      buildAboutText(),
    ],
  );

  Widget buildAboutText() => Container(
    child: Center(
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: 320,
              height: 30,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          size: 20,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'You’re offline.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: 180,
                  height: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 40,
                              color: Color(0xFF0CBC8B),
                            ),
                            SizedBox(width: 5),
                            Column(
                              children: <Widget>[
                                Text('Earning Balance:',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: <Widget>[
                                    Text('₱ 1,500',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: 130,
                  height: 60,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Column(
                              children: <Widget>[
                                Text('Total Passengers',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('4',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 32,
                                        color: Color(0xFFCCCCCC),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}