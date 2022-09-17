import 'package:animate_do/animate_do.dart';
import 'package:ehatid_driver_app/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intro_slider/intro_slider.dart';


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
     body: SingleChildScrollView(
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
                   child: Image.asset("assets/images/Vector 3.png",
                     width: size.width,
                   ),
                 ),
                 Positioned(
                   bottom: 0,
                   child: Image.asset("assets/images/Vector 2.png",
                     width: size.width,
                  ),
                 ),
               ],
             ),
           ),
            Container(
             margin: const EdgeInsets.fromLTRB(30, 60, 30, 0),
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
                 FadeInDown(
                   child: Container(
                     margin: const EdgeInsets.symmetric(vertical: 15),
                     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                 FadeInDown(
                  child: MaterialButton(
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
                 FadeInDown(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Already have an account?", style: TextStyle(
                           color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 16, letterSpacing: -0.5, fontWeight: FontWeight.w500
                         ),),
                         TextButton(
                             onPressed: () {},
                             child: Text("Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,  letterSpacing: -0.5, fontWeight: FontWeight.w600),),
                         )
                       ],
                     ),
                 ),
                 FadeInDown(
                   child:  OrDivider(),
                 ),
                 FadeInDown(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget> [
                         SocialIcons(iconSrc: "assets/images/google.png",
                         press: () {},
                         ),
                         SocialIcons2(iconSrc: "assets/images/facebook.png",
                           press: () {},
                         ),
                         SocialIcons3(iconSrc: "assets/images/twitter.png",
                           press: () {},
                         ),
                       ],
                     ),
                 ),
               ],
             ),
           )
         ],
       ),
     ),
    );
  }
}

class SocialIcons extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocialIcons({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Color(0xFFC5331E),
        ),
        shape: BoxShape.circle,
        color: Color(0xFFC5331E),
      ),
      child: Image.asset(iconSrc,
      height: 40,
      width: 40,),
      ),

    );
  }
}

class SocialIcons2 extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocialIcons2({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Color(0xFF4E6297),
          ),
          shape: BoxShape.circle,
          color: Color(0xFF4E6297),
        ),
        child: Image.asset(iconSrc,
          height: 40,
          width: 40,),
      ),

    );
  }
}

class SocialIcons3 extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocialIcons3({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Color(0xFF55ACE3),
          ),
          shape: BoxShape.circle,
          color: Color(0xFF55ACE3),
        ),
        child: Image.asset(iconSrc,
          height: 40,
          width: 40,),
      ),

    );
  }
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: Row(
        children: <Widget> [
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Text("Or sign up using", style: TextStyle(
              color: Color(0xFF494949),
              fontWeight: FontWeight.w500, fontFamily: 'Montserrat', fontSize: 14, letterSpacing: -0.5,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
          child: Divider(
            color: Color(0xFF272727),
          ),
        );
  }
}
