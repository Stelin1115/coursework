// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'BottomNavigationBar/BottomNavigation.dart';

void main() {
  runApp(MaterialApp(
    // showPerformanceOverlay: true,
    debugShowCheckedModeBanner: false,
    home: BottomNavigationScreen(
      pageno: 0,
    ),
  ));
}
