import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'AppColors.dart';

/// @date:2020-01-14
/// @author:Silence
/// @describe:
class DataUtils {
  static bool isEmpty(String msg) {
    return msg == null || msg.length == 0;
  }

  static bool listIsEmpty(List list) {
    return list == null || list.length == 0;
  }

  static String replaceAll(String str) {
    str = str.replaceAll("&ldquo;", "\"");
    str = str.replaceAll("&rdquo;", "\"");
    str = str.replaceAll("&quot;", "\"");
    str = str.replaceAll("&mdash;", "\—");
    str = str.replaceAll("&amp;", "\&");
    str = str.replaceAll("&middot;", "\·");
    str = str.replaceAll("&hellip;", "\.\.\.");
    return str;
  }

  static getFormatData(int millisecondsSinceEpoch, String format) {
    var dataFormat = new DateFormat(format);
    var dateTime =
        new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    String formatResult = dataFormat.format(dateTime);
    return formatResult;
  }

  static TextSpan getTextSpan(String text, String key) {
    if (text == null || key == null) {
      return null;
    }

    if (text == null || key == null) {
      return null;
    }

    String splitString1 = "<em class='highlight'>";
    String splitString2 = "</em>";

    String textOrigin =
        text.replaceAll(splitString1, '').replaceAll(splitString2, '');

    TextSpan textSpan = new TextSpan(
        text: key, style: new TextStyle(color: AppColors.colorPrimary));

    List<String> split = textOrigin.split(key);

    List<TextSpan> list = new List<TextSpan>();

    for (int i = 0; i < split.length; i++) {
      list.add(new TextSpan(text: split[i]));
      list.add(textSpan);
    }

    list.removeAt(list.length - 1);

    return new TextSpan(children: list);
  }
}
