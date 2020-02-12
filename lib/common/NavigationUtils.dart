import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/SpUtils.dart';
import 'package:silence_wan_android/user/login/LoginPage.dart';

/// @date:2020-02-11
/// @author:Silence
/// @describe:
class NavigationUtils {
  static void pushPage(
    BuildContext context,
    Widget page, {
    bool needLogin = false,
  }) {
    if (context == null || page == null) return;
    SpUtils.isLogin().then((isLogin) {
      if (!isLogin && needLogin) {
        pushPage(context, LoginPage());
        return;
      } else {
        Navigator.push(
            context, new MaterialPageRoute<void>(builder: (context) => page));
      }
    });
  }
}
