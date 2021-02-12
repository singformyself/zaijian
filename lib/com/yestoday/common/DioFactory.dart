import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFactory {

  static Dio defaultDio() {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.json;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 5000;
    dio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return dio;
  }

  static Dio tokenDio() {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.json;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 15000;
    String token = '';
    SharedPreferences.getInstance()
        .then((storage) => {token = storage.getString('token')});
    dio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      HttpHeaders.contentTypeHeader: 'application/json',
      'token': token
    };
    return dio;
  }
}
