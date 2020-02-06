import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/Strings.dart';

/// @date:2020-01-24
/// @author:Silence
/// @describe: 系统设置
class SystemSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SystemSettingPage();
}

class _SystemSettingPage extends State<SystemSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Strings.systemSetting),
      centerTitle: true,
    ));
  }
}
