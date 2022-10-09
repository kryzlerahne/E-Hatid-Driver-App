import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ehatid_driver_app/homescreen.dart';
import 'package:ehatid_driver_app/login.dart';
import 'package:ehatid_driver_app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  User? currentFirebaseUser;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "first_name": _firstNameController.text.trim(),
        "last_name": _firstNameController.text.trim(),
        "email": _emailController.text.trim(),
        "username": _userNameController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomePage()));
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  /**Future addUserDetails(String firstName, String lastName, String email,
      String username, String password) async {
    await FirebaseFirestore.instance.collection('drivers').add({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'password': password,
    });
  }**/

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  final formkey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHidden2 = true;

  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFFCEA),
      body: SafeArea(
        child: Container(
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
              Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Personal Details", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.account_circle_rounded,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Contact Details", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.email_outlined,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Align(
                          alignment: Alignment(-1, 0),
                          child: Row(
                            children: <Widget> [
                              SizedBox(width: 20.sp),
                              Text(
                                "Account Details", textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 33, 33, 33),
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 10.sp),
                              Icon(
                                Icons.contact_mail_outlined,
                                size: 25.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 2,
                          indent: 20.sp,
                          endIndent: 20.sp,
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Username",
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username.';
                              } else if (value.length < 4) {
                                return "Choose a username with 4 or more characters.";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Password",
                              suffixIcon: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
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
                        SizedBox(height: 1.5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
                          child: TextFormField(
                            controller: _confirmpasswordController,
                            obscureText: _isHidden2,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFFED90F),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Confirm Password",
                              suffixIcon: InkWell(
                                onTap: _toggleConfirmPasswordView,
                                child: Icon(
                                  _isHidden2 ? Icons.visibility : Icons.visibility_off,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Color(0xbc000000),
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.sp),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please re-enter your password.';
                              } else if (value.length < 8) {
                                return "Length of password must be 8 or greater.";
                              } else if (value != _passwordController.text) {
                                return "Password mismatch.";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        SizedBox(
                          height: 30.sp,
                          width: 50.w,
                          child: MaterialButton(
                            onPressed: (){
                              if(formkey.currentState!.validate()){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Success"),
                                ));
                                signUp();
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                                );
                              }
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account already?",
                              style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFFFEDF3F),
                                ),
                              ),
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
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }
}

class ProgressDialog extends StatelessWidget
{
  String? message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              const SizedBox(width: 6.0,),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),

              const SizedBox(width: 26.0,),

              Text(
                message!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
