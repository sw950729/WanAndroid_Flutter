import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 关于我
class AboutMinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutMinePage();
}

class _AboutMinePage extends State<AboutMinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Strings.aboutMine),
      centerTitle: true,
    ));
  }
}
