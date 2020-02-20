import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:silence_wan_android/common/AppColors.dart';

class ConfigInfo {
  Color theme = AppColors.colorPrimary;
}

class ConfigModel extends ConfigInfo with ChangeNotifier {
  Future $setTheme(payload) async {
    theme = payload;
    notifyListeners();
  }
}
