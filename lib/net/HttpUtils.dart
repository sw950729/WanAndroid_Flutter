import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:silence_flutter_study/common/Logger.dart';
import 'package:silence_flutter_study/net/ApiUrl.dart';

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
    dio.interceptors.add(CookieManager(CookieJar()));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) {
      return error;
    }));
  }

  void request(String url, Function successCallback,
      {data, options, method}) async {
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
      if (successCallback != null) {
        successCallback(json.decode(response.toString())['data']);
      }
      Logger.d('响应数据：' + response.toString());
    } else {
      Logger.d('请求出错：' +
          response.statusCode.toString() +
          "," +
          response.statusMessage);
      return null;
    }
  }
}
