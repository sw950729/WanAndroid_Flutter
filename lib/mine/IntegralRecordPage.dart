import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_flutter_study/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 积分记录
class IntegralRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntegralRecordPage();
}

class _IntegralRecordPage extends State<IntegralRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Strings.coinCountHistory),
      centerTitle: true,
    ));
  }
}
