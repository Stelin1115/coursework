import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Colors/colors.dart';

var loader = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // SpinKitWave()

    SpinKitFadingCube(color: HexColor("#2d753e"), size: 12),
    SpinKitFadingCube(color: HexColor("#2d753e"), size: 12),
    SpinKitFadingCube(color: HexColor("#2d753e"), size: 12),
  ],
);
