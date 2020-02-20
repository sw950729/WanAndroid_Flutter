import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class SpUtils {
  static const String IS_LOGIN = "isLogin";
  static const String USERNAME = "userName";
  static const String COOKIE = "cookie";
  static const String USER_GUID = "userGuid";
  static const String THEME = "theme";

  // 保存用户登录信息，data中包含了userName
  static Future saveLoginInfo(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(USERNAME, userName);
    await sp.setBool(IS_LOGIN, true);
  }

  static Future clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }

  static Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USERNAME);
  }

  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool b = sp.getBool(IS_LOGIN);
    return true == b;
  }

  static Future saveCookie(String cookie) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(COOKIE, cookie);
  }

  static Future<String> getCookie() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(COOKIE);
  }

  static Future saveUserGuid(int userGuid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt(USER_GUID, userGuid);
  }

  static Future<int> getUserGuid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(USER_GUID);
  }

  static Future<int> getTheme() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(THEME);
  }

  static Future saveTheme(int position) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt(THEME, position);
  }
}
