import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/SpUtils.dart';
import 'package:silence_flutter_study/main/MainPage.dart';
import 'package:silence_flutter_study/login/LoginPage.dart';

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
      body: Image.asset('images/splash_bg.png',width: double.infinity,height: double.infinity,),
    );
  }

  void countDown() {
    var duration = Duration(seconds: 3);
    Future.delayed(duration, gotoHomePage);
  }

  void gotoHomePage() {
    if (!isStartHomePage) {
      SpUtils.isLogin().then((isLogin) {
        if (!isLogin) {
          _login();
        } else {
          _launchMain();
        }
      });
      isStartHomePage = true;
    }
  }

  _login() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> rout) => false);
  }

  _launchMain() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> rout) => false);
  }
}
