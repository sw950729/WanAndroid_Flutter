import 'package:flutter/cupertino.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class Logger {
  static var _separator = "=";
  static var _isDebug = true;
  static int _limitLength = 2000;

  static void init({@required bool isDebug, int limitLength}) {
    _isDebug = isDebug;
    _limitLength = limitLength ??= _limitLength;
    var endLineStr = StringBuffer();
    endLineStr.write(_separator);
  }

  //仅Debug模式可见
  static void d(dynamic obj) {
    if (_isDebug) {
      _log(obj.toString());
    }
  }

  static void v(dynamic obj) {
    _log(obj.toString());
  }

  static void _log(String msg) {
    if (msg.length < _limitLength) {
      print(msg);
    } else {
      segmentationLog(msg);
    }
  }

  static void segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          print(remainderStr);
          break;
        }
      }
    }
  }

}
