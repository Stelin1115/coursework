// ignore_for_file: prefer_const_constructors, unused_local_variable, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework/Authentication/AuthenticationMain/SignUpScreen.dart';
import 'package:coursework/Constants/Colors/colors.dart';
import 'package:coursework/Constants/Loader/Loader.dart';
import 'package:coursework/Constants/TextStyle/Textstyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../BottomNavigationBar/BottomNavigation.dart';
import '../Authentication-Reusable/Login-reusable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController loginemailcontroller = TextEditingController();
  TextEditingController loginpasswordcontroller = TextEditingController();
  bool showPassword = true;
  bool _isLoading = false;
  String? bodyError;
  var token;

  @override
  void initState() {
    super.initState();
  }

  void obscurepsw() {
    setState(() => showPassword = !showPassword);
  }

  void navigation() {}

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In",
                      style: authheadingstyle,
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Text(
                      "We are happy to see you here!",
                      style: authsubheadingstyle,
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Container(
                        height: screenHeight * 0.28,
                        width: screenWidth,
                        child: Image(
                            image: AssetImage("assets/images/login.png"))),
                    SizedBox(height: screenHeight * 0.04),
                    logintextform(loginemailcontroller),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    textformpassword(
                        loginpasswordcontroller, obscurepsw, showPassword),
                    SizedBox(
                      height: screenHeight * 0.000002,
                    ),
                    bodyError != null
                        ? Text(
                            bodyError.toString(),
                            style: TextStyle(color: Colors.red),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: screenHeight * 0.000001,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {
                            navigation();
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: authcommonnavigationtextcolor,
                          )),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    _isLoading
                        ? loader
                        : Container(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: ElevatedButton(
                              child: Text(
                                "Login",
                                style: buttontextstyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#2ADB7F"),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                loginUser(loginemailcontroller.text,
                                    loginpasswordcontroller.text);
                              },
                            ),
                          ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have an Account ",
                          style: authcommonnavigationtextcolor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SignUpScreen()),
                            );
                          },
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                                color: HexColor("#2ADB7F"),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Center(
                        child: Text(
                      "OR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      height: screenHeight * 0.001,
                    ),
                    Center(
                        child: Container(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.08,
                      child: GestureDetector(
                        onTap: () {
                          _signInWithGoogle(context);
                        },
                        child: Image.asset('assets/images/google.png',
                            fit: BoxFit.cover),
                      ),
                    )
                        // child: IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.facebook),
                        //   iconSize: 40,
                        // ),
                        )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    if (email.isNotEmpty || password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(
                    pageno: 0,
                  )),
        );
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          bodyError = "Invalid Email Or Password";
        });
        print('Error during login: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
        bodyError = "Enter Details First !!!";
      });
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuth =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          // User signed in, save data to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'email': user.email,
            'name': user.displayName,
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(
                    pageno: 0,
                  )));
        }
      }
    } catch (error) {
      print('Google sign in error: $error');
    }
  }
}
