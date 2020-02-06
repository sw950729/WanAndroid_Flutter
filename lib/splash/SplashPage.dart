import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silence_wan_android/main/MainPage.dart';

/// @date:2020-01-16
/// @author:Silence
/// @describe:
class SplashState extends StatefulWidget {
  @override
  State<SplashState> createState() => _SplashWidget();
}

class _SplashWidget extends State<SplashState> {
  bool isStartHomePage = false;

  @override
  void initState() {
    super.initState();
    countDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'images/splash_bg.png',
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  void countDown() {
    var duration = Duration(seconds: 3);
    Future.delayed(duration, gotoHomePage);
  }

  void gotoHomePage() {
    if (!isStartHomePage) {
      _launchMain();
    }
    isStartHomePage = true;
  }

  _launchMain() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> rout) => false);
  }
}
