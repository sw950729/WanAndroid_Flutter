import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:silence_flutter_study/common/DataUtils.dart';
import 'package:silence_flutter_study/common/Logger.dart';
import 'package:silence_flutter_study/common/SpUtils.dart';
import 'package:silence_flutter_study/net/ApiUrl.dart';

/// @date:2020-01-16
/// @author:Silence
/// @describe:
class HttpUtils {
  static HttpUtils _httpUtils;
  BaseOptions options;
  Dio dio;
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  static const String GET = 'get';
  static const String POST = 'post';

  static HttpUtils getInstance() {
    if (_httpUtils == null) {
      _httpUtils = HttpUtils();
    }
    return _httpUtils;
  }

  HttpUtils() {
    options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        contentType: ContentType.json,
        responseType: ResponseType.json);
    dio = Dio(options);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) {
      return error;
    }));
  }

  void setCookie(String cookie) {
    Map<String, dynamic> _headers = new Map();
    _headers["Cookie"] = cookie;
    dio.options.headers.addAll(_headers);
  }

  void request(String url, Function successCallback,
      {data, options, method}) async {
    await SpUtils.getCookie().then((cookie) {
      if (!DataUtils.isEmpty(cookie)) {
        setCookie(cookie);
      }
    });
    method = method ?? GET;
    Response response;
    try {
      if (method == GET) {
        url = ApiUrl.baseUrl + url;
        Logger.d('请求地址：' + url);
        if (data != null && data.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          data.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }
        Logger.d('入参数据：' + data.toString());
        response = await dio.get(url, queryParameters: data, options: options);
      } else if (method == POST) {
        url = ApiUrl.baseUrl + url;
        Logger.d('请求地址：' + url);
        Logger.d('入参数据：' + data.toString());
        response = await dio.post(url, queryParameters: data, options: options);
      }
    } on DioError catch (e) {
      Logger.d('请求出错：' + e.toString());
    }
    if (HttpStatus.ok == response.statusCode) {
      if (successCallback != null &&
          json.decode(response.toString())['errorCode'] == 0) {
        successCallback(json.decode(response.toString())['data']);
      } else {
        Fluttertoast.showToast(
            msg: json.decode(response.toString())['errorMsg']);
      }
      Logger.d('响应数据：' + response.toString());
      if (url == ApiUrl.baseUrl + ApiUrl.login) {
        response.headers.forEach((String name, List<String> values) {
          if (name == "set-cookie") {
            String cookie = values.toString();
            SpUtils.saveCookie(cookie);
          }
        });
      }
    } else {
      Logger.d('请求出错：' +
          response.statusCode.toString() +
          "," +
          response.statusMessage);
      return null;
    }
  }
}
