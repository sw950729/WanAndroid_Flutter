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
    return str;
  }
}
