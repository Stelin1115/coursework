// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:coursework/BottomNavigationBar/BottomNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Authentication/AuthenticationMain/SigninScreen.dart';

var token;
void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  token = localStorage.getString('token');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: CheckAuthStatus(),
    );
  }
}

class CheckAuthStatus extends StatefulWidget {
  const CheckAuthStatus({super.key});

  @override
  _CheckAuthStatusState createState() => _CheckAuthStatusState();
}

class _CheckAuthStatusState extends State<CheckAuthStatus> {
  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showSplash = prefs.getBool('showSplash') ?? true;

    if (showSplash) {
      // Show splash screen for the first time
      prefs.setBool('showSplash', false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      // Check user's authentication status
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is already logged in, navigate to home screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationScreen(
                      pageno: 0,
                    )));
      } else {
        // User is not logged in, navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// class PrivacyPolicy {
//   static showAlertDialog(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     // Widget okButton = ElevatedButton(
//     //   child: Text("OK"),
//     //   onPressed: () {},
//     // );
//     AlertDialog alert = AlertDialog(
//       backgroundColor: HexColor("#F3FFF1"),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       title:
//           Center(child: Image(image: AssetImage("assets/images/newlogo1.png"))),
//       content: SizedBox(
//         height: screenHeight * 0.25,
//         width: screenWidth * 0.3,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "Disclaimer",
//               style: authheadingstyle,
//             ),
//             SizedBox(
//               height: screenHeight * 0.025,
//             ),
//             Text(
//               "This application is released as a trial version for testing purpose",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(
//               height: screenHeight * 0.01,
//             ),
//             Text(
//               "This application might contain some faults as it is a testing version.",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//       ),
//       actions: const [],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
// }
