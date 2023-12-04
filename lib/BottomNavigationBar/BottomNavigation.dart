// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:coursework/MainScreen/HomeScreen.dart';
import 'package:coursework/MainScreen/Profile.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Constants/Colors/colors.dart';
import '../MainScreen/AddtoCart.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int pageno;
  const BottomNavigationScreen({super.key, required this.pageno});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int maxCount = 4;
  late StreamSubscription _subscription;
  String netstatus = '';
  final int _currentPage = 0;
  final _pageController = PageController(initialPage: 0);

  Widget? _child;
  var _currentIndex = 0;
  @override
  void initState() {
    _currentIndex = widget.pageno;
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  final List<Widget> _screens = [
    HomeScreen(),
    AddToCartScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        curve: Curves.linear,
        backgroundColor: HexColor("#e6ffe6"),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.class_),
            title: Text("Classes"),
            selectedColor: Colors.greenAccent.shade700,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.cabin),
            title: Text("Card"),
            selectedColor: Colors.greenAccent.shade700,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("profile"),
            selectedColor: Colors.greenAccent.shade700,
          ),
        ],
      ),
    );
  }
}
