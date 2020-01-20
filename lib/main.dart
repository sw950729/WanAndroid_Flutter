import 'package:flutter/material.dart';
import 'package:silence_flutter_study/splash/SplashPage.dart';

void main() {
  runApp(new FlutterStudyApp());
}

class FlutterStudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SplashState(),
    );
  }
}
