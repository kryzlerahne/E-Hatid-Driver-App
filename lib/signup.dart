import 'package:animate_do/animate_do.dart';
import 'package:ehatid_driver_app/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFED90F),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Color(0xFFFEDF3F),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
     body: Center(
       child: Stack(
         children: <Widget>[
           Container(
             height: size.height,
             width: double.infinity,
             child: Stack(
               alignment: Alignment.center,
               children: <Widget>[
                 Positioned(
                   top: 0,
                   child: Image.asset("assets/images/Vector 1.png",
                     width: size.width,
                   ),
                 ),
               ],
             ),
           ),
           FadeAnimation(1,
               Container(
             margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget> [
                 Image.asset("assets/images/illus12.png",
                   width: 200
                 ),
                 Text(
                   "Sign-up to E-Hatid",
                   style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                 ),
                 Text(
                   "Be part of the TODA G5 Lourdes Terminal", textAlign: TextAlign.center,
                   style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                 ),
                 FadeAnimation(1,
                   Container(
                     margin: const EdgeInsets.symmetric(vertical: 15),
                     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       boxShadow: [
                         BoxShadow(
                           color: Color(0xffeeeeee),
                           blurRadius: 10,
                           offset: Offset(0,4)
                         )
                       ],
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(color: Colors.black.withOpacity(0.13))
                     ),
                     child: Stack(
                       children: [
                         InternationalPhoneNumberInput(
                           onInputChanged: (value) {},
                           cursorColor: Colors.black,
                           formatInput: false,
                           initialValue: PhoneNumber(isoCode: 'PH', dialCode:'+63'),
                           selectorConfig: SelectorConfig(
                             selectorType: PhoneInputSelectorType.BOTTOM_SHEET
                           ),
                           inputDecoration: InputDecoration(
                             contentPadding: EdgeInsets.only(bottom: 15, left: 0),
                             border: InputBorder.none,
                             hintText: 'Phone Number',
                             hintStyle: TextStyle(
                               color: Colors.grey.shade500, fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w400
                             )
                           ),
                         ),
                         Positioned(
                           left: 85,
                           top: 8,
                           bottom:8,
                           child: Container(
                             height: 40,
                             width: 1,
                             color: Colors.black.withOpacity(0.13),
                           ),
                         )
                       ],
                     ),
                   ),
                 ),
                 FadeAnimation(1,
                  MaterialButton(
                       onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                       },
                     color: Colors.black,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(50)
                     ),
                     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                     minWidth: double.infinity,
                     child: Text("Sign up with Phone", style: TextStyle(
                       color: Colors.white, fontFamily: 'Montserrat', fontSize: 14
                     ),),
                   ),
                 ),
               ],
             ),
           )
           ),
         ],
       ),
     ),
    );
  }
}
