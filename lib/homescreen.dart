import 'dart:async';
import 'package:ehatid_driver_app/accept_decline.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/navigation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final panelController = PanelController();
  final Completer<GoogleMapController?> _controller = Completer();

  bool _activeButton = true;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7752, 121.0453),
    zoom: 18.4746,
  );


  static final CameraPosition _kLake = CameraPosition(
    //bearing: 192.8334901395799,
      target: LatLng(13.7731, 121.0484),
      //tilt: 59.440717697143555,
      zoom: 107.15);
  
  static double OnlineGo = Adaptive.h(21);
  double GoOnlineHeight = OnlineGo;

  int counter = 0;

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
              body: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
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
                  width: Adaptive.w(40),    // This will take 20% of the screen's width
                  height: 5.h,
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
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19)
          ),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Container(
                  height: 53.0,
                  decoration: BoxDecoration(
                    color: Color(0XFF0CBB8A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("Passengers Near You",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Column(
                          children: [
                            new Text(
                              "Karlo Pangilinan",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              "112m away",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF0CBC8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (_) => AcceptDecline()
                          ),
                          );
                        },
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                          color: Color(0xFF777777),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Color(0xFF777777),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            new Text(
                              "Danna Aguda",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              "157m away",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF0CBC8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){},
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                          color: Color(0xFF777777),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Color(0xFF777777),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            new Text(
                              "Mar Mandigma",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              "201m away",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF0CBC8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){},
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                          color: Color(0xFF777777),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Color(0xFF777777),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            new Text(
                              "Jean Falcatan",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              "292m away",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF0CBC8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){},
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                          color: Color(0xFF777777),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Color(0xFF777777),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          children: [
                            new Text(
                              "Kevin Ortega",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF272727),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            new Text(
                              "305m away",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Color(0xFF0CBC8B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){},
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 40,
                          color: Color(0xFF777777),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 25,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    icon: Icon(Icons.power_settings_new_rounded, size: 17),
  );
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
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              width: Adaptive.w(90),
              height: 5.h,
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
                  width: Adaptive.w(48),
                  height: 10.h,
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
                  width: Adaptive.w(40),
                  height: 10.h,
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