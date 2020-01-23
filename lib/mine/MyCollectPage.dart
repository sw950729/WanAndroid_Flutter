import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 我的收藏
class MyCollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyCollectPage();
}

class _MyCollectPage extends State<MyCollectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Strings.myCollect),
      centerTitle: true,
    ));
  }
}
