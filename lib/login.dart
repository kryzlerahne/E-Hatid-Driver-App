import 'package:animate_do/animate_do.dart';
import 'package:ehatid_driver_app/forgot_pw_page.dart';
import 'package:ehatid_driver_app/intro_slider.dart';
import 'package:ehatid_driver_app/main_page.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('initScreen', 1);
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
    ).whenComplete((){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final loginform = GlobalKey<FormState>();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: Form(
        key: loginform,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
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
                  child: Image.asset("assets/images/Vector 4.png",
                    width: size.width,
                  ),
                ),
              ],
            ),
          ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 60, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/illus14.png",
                        width: Adaptive.h(50),
                        height: Adaptive.h(30),
                    ),
                    Text(
                      "Sign in to your account",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 28, letterSpacing: -2, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome Back! Ready for your next ride?", textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xff272727), letterSpacing: -0.5, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: Adaptive.h(3)),
                    SizedBox(
                      width: Adaptive.w(85),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F),),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.person, color: Color(0xffCCCCCC)),
                          hintStyle: TextStyle( color: Color(0xbc000000),
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                      ),
                    ),
                    SizedBox(height: Adaptive.h(1.5)),
                    SizedBox(
                      width: Adaptive.w(85),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFED90F),),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock, color: Color(0xffCCCCCC)),
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xffCCCCCC),
                            ),
                          ),
                          hintStyle: TextStyle( color: Color(0xbc000000),
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          } else if (value.length < 8) {
                            return "Length of password must be 8 or greater.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return  ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: Text("Forgot Password?", style: TextStyle(fontFamily: 'Montserrat', fontSize: 14,
                              letterSpacing: -0.5, fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      onPressed: signIn,
                      color: Color(0xFFFED90F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      minWidth: Adaptive.w(85),
                      child: Text("Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: Adaptive.h(2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account yet?", style: TextStyle(
                            color: Color(0xFF494949), fontFamily: 'Montserrat', fontSize: 15, letterSpacing: -0.5, fontWeight: FontWeight.w500
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (_) => SignUpPage(),
                            ),
                            );
                          },
                          child: Text("Register", style: TextStyle(fontFamily: 'Montserrat', fontSize: 16,
                            letterSpacing: -0.5, fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline, color:Color(0xFFFEDF3F),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

