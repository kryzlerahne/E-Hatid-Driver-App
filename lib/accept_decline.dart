import 'dart:async';
import 'package:ehatid_driver_app/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

List cars = [
  {'id': 0, 'name': 'Select a ride', 'price': 0.0},
  {'id': 1, 'name': 'Uber', 'price': 1.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
  {'id': 3, 'name': 'Grab', 'price': 3.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
  {'id': 2, 'name': 'Grab', 'price': 2.0},
];

class AcceptDecline extends StatefulWidget {
  @override
  State<AcceptDecline> createState() => AcceptDeclineState();
}

class AcceptDeclineState extends State<AcceptDecline> {
  Completer<GoogleMapController> _controller = Completer();

  final panelController = PanelController();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.7731, 121.0484),
    zoom: 14.4746,
  );

  static final Marker _kPickUpMarker = Marker(
    markerId: MarkerId('_kPickUp'),
    infoWindow: InfoWindow(title: 'Passenger Location'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(13.7731, 121.0484),
  );

  static final Marker _kDestinationMarker = Marker(
    markerId: MarkerId('_kDestination'),
    infoWindow: InfoWindow(title: 'Destination'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(13.7991, 121.0478),
  );

  static final CameraPosition _kLake = CameraPosition(
      //bearing: 192.8334901395799,
      target: LatLng(13.7731, 121.0484),
      //tilt: 59.440717697143555,
      zoom: 107.15);

  @override
  Widget build(BuildContext context) {
    final paneHeightClosed = MediaQuery.of(context).size.height * 0.12;
    final paneHeightOpen = MediaQuery.of(context).size.height * 0.45;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFED90F),
        title: Text('Trip Details',
        style:TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: paneHeightClosed,
        maxHeight: paneHeightOpen,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        color: Color(0xFFEBE5D8),
        body: GoogleMap(
          mapType: MapType.normal,
          markers: {_kPickUpMarker, _kDestinationMarker},
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
    );
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
      SizedBox(height: 12),
      buildDragHandle(),
      SizedBox(height: 18),
      buildAboutText(context),
    ],
  );

 Widget buildAboutText(BuildContext context) => Container(
   padding: EdgeInsets.symmetric(horizontal: 24),
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Row(
         //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget> [
           Icon(Icons.account_circle,
             size: 40,
           color: Color(0xFF272727),
           ),
          SizedBox(width: 20,),
           Column(
             children: [
               Row(
                 children: [
                   Text("Karlo Pangilinan ",
                     style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,
                     ),
                   ),
                   Icon(Icons.verified_rounded,
                     color: Color(0xFF0CBC8B),),
                 ],
               ),
               Row(
                 children: [
                   SizedBox(width: 10,),
                   Text("Verified Passenger",
                   style: TextStyle(fontFamily: 'Montserrat', fontSize: 15,
                   ),
                   ),
                   SizedBox(width: 50,),
                 ],
               ),
             ],
           ),
           Spacer(),
           Icon(Icons.call,
             size: 40,
             color: Color(0xFF0CBC8B),
           ),
         ],
       ),
       SizedBox(height: 25,),
       Row(
         children: [
           SizedBox(width: 15,),
           Image.asset("assets/images/line.png"),
           SizedBox(width: 30,),
           Column(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Text("Pickup Point:",
               style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600,color: Color(0XFF9E9E9E)),),
               Text("7-Eleven, Bolbok, Batangas City",
               style: TextStyle(fontFamily: 'Montserrat',),), //PLACE YOUR LOCATION HERE
               SizedBox(height: 10,),
               Center(
                 child: Container(
                   width: 280,
                   height: 2,
                   decoration: BoxDecoration(
                     color: Color(0XFFCCC9C1),
                     borderRadius: BorderRadius.circular(32),
                   ),
                 ),
               ),
               SizedBox(height: 10,),
               Text("Destination:",
                 style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),),
               Text("Sta. Rita de Cascia Parish Church",
               style: TextStyle(fontFamily: 'Montserrat',),),
             ],
           ),
         ],
       ),
       SizedBox(height: 30,),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           Text("Distance",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
           ),
           Text("Time",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,),
           ),
         ],
       ),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           //SizedBox(height: 20,),
           Text("192m away",
             style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600,color: Color(0XFFFFBA4C)),
           ),
           Text("15 mins",
             style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0XFFFFBA4C)),
           ),
         ],
       ),
       SizedBox(height: 20, width: 20,),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           MaterialButton(
             onPressed: (){
               showDialog(
                 context: context,
                 builder: (context) => BookingSuccessDialog(),
               );
             },
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(50)
             ),
             minWidth: 150,
             child: Text("Continue", style: TextStyle( color: Colors.white,
               fontSize: 15,
               fontFamily: "Montserrat",
               fontWeight: FontWeight.w600,),),
             color: Color(0XFF0CBC8B),
           ),
           MaterialButton(
             onPressed: (){
             },
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(50)
             ),
             minWidth: 150,
             child: Text("Cancel", style: TextStyle( color: Colors.white,
               fontSize: 15,
               fontFamily: "Montserrat",
               fontWeight: FontWeight.w600,),),
             color: Color(0XFFC5331E),
           ),
         ],
       ),
     ],
   ),
 );

 Widget buildDragHandle() => GestureDetector(
   child: Center(
     child: Container(
       width: 50,
       height: 5,
       decoration: BoxDecoration(
         color: Color(0XFFD1D1D1),
         borderRadius: BorderRadius.circular(32),
       ),
     ),
   ),
   onTap: togglePanel,
 );

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}

class BookingSuccessDialog extends StatelessWidget {
  final _priceController = TextEditingController();
  BookingSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19)
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
              Container(
                height: 70.0,
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
                    child: Column(
                      children: [
                        Text("Booking Successful!",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Passenger ID: 554321",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Form(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 80,),
                      Text("PHP",
                        style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                        Flexible(
                          child: SizedBox(
                            width: 120,
                            child: TextField(
                              decoration: InputDecoration(hintText: "Fare Price",
                                hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                //isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),),
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40,),
                Text("Base Fare:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 150,),
                Text("P40.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Booking Fee:",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 130,),
                Text("P10.00",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Center(
              child: Container(
                width: 260,
                height: 1.5,
                decoration: BoxDecoration(
                  color: Color(0XFFCCC9C1),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
                child: Text(
                    "Don't worry! Additional charges \n may apply if cancellation of booking \n is done by the passenger.",
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
            ),
            SizedBox(height: 20,),
            MaterialButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => DriverMap(),
                ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              minWidth: 150,
              child: Text("Get Directions", style: TextStyle( color: Colors.white,
                fontSize: 15,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,),),
              color: Color(0XFF0CBB8A),
            ),
          ],
        ),
      ),
    );
  }
}
