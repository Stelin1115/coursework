// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework/Authentication/AuthenticationMain/SigninScreen.dart';
import 'package:coursework/Constants/Colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CollectionReference voice =
      FirebaseFirestore.instance.collection('users');

  String? userName;

  @override
  void initState() {
    print("januyan edit profile");
    Future.delayed(Duration(milliseconds: 1), () {
      getCurrentUserId();
    });
    super.initState();
  }

  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var test;
      String userId = user.uid;
      print('Current User ID: $userId');
      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get()
          .then((DocumentSnapshot doc) {
        var item = doc.data() as Map<String, dynamic>;

        var name = item['name'];

        setState(() {
          userName = name;
        });
      });
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          children: [
            // User card
            BigUserCard(
              backgroundColor: primarygreyDark,
              userName: userName ?? "",
              userProfilePic: AssetImage("assets/images/signup.png"),
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Modify",
                subtitle: "Tap to change your data",
                onTap: () {},
              ),
            ),

            SettingsGroup(items: [
              SettingsItem(
                onTap: () {},
                icons: CupertinoIcons.pencil_outline,
                iconStyle: IconStyle(),
                title: 'LeaderBoard',
                subtitle: "Global Leader Board ",
              ),
            ]),

            SettingsGroup(
              items: [
                SettingsItem(
                  icons: Icons.graphic_eq_sharp,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Yoga Schedule',
                ),
                SettingsItem(
                  icons: Icons.language,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.green,
                  ),
                  title: 'World Yoga ',
                ),
              ],
            ),
            // ToggleSwitch(
            //   initialLabelIndex: 2,
            //   totalSwitches: 3,
            //   labels: ['Sinhala', 'Tamil', 'English'],
            //   onToggle: (index) {
            //     if (index == 0) {
            //       voice.doc(CurrentUID).update({'language': "Sinhala"});
            //     } else if (index == 1) {
            //       voice.doc(CurrentUID).update({'language': "Tamil"});
            //     } else {
            //       voice.doc(CurrentUID).update({'language': "English"});
            //     }
            //   },
            // ),

            // GestureDetector(
            //   onTap: () {},
            //   child: SettingsGroup(
            //     items: [
            //       SettingsItem(
            //         onTap: () {},
            //         icons: Icons.image_aspect_ratio,
            //         iconStyle: IconStyle(
            //           backgroundColor: Colors.purple,
            //         ),
            //         title: 'ImageCaption',
            //         subtitle: "Caption Your Image",
            //       ),
            //     ],
            //   ),
            // ),
            // You can add a settings title
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () {
                    signOutUser();
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                  titleStyle: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SettingsItem(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PaymentGatewayScreen(
                    //             payamount: '12',
                    //           )),
                    // );
                  },
                  icons: CupertinoIcons.star_circle_fill,
                  title: "Upgrade to Premium",
                  titleStyle: TextStyle(
                    color: primarygreyLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Here, default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
    );
  }

  Future<void> signOutUser() async {
    PanaraConfirmDialog.showAnimatedGrow(
      context,
      title: "Are You Sure",
      message: "SignOut From App",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      color: Colors.red,
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () async {
        try {
          Navigator.of(context, rootNavigator: true).pop();
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } catch (e) {
          print('Error during sign out: $e');
        }
      },
      panaraDialogType: PanaraDialogType.success,
      barrierDismissible: false, // optional parameter (default is true)
    );
  }
}
