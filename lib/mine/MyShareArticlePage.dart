import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 我的分享文章
class MyShareArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyShareArticlePage();
}

class _MyShareArticlePage extends State<MyShareArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Strings.myShareArticle),
      centerTitle: true,
    ));
  }
}
