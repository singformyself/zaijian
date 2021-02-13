import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFactory {
  static Dio defDio= Dio();
  static Dio tDio= Dio();

  static Dio defaultDio() {
    defDio.options.responseType = ResponseType.json;
    defDio.options.connectTimeout = 5000; //5s
    defDio.options.receiveTimeout = 5000;
    defDio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      HttpHeaders.connectionHeader: 'keep-alive',
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return defDio;
  }

  static Dio tokenDio() {
    tDio.options.responseType = ResponseType.json;
    tDio.options.connectTimeout = 5000; //5s
    tDio.options.receiveTimeout = 15000;
    String token = '';
    SharedPreferences.getInstance()
        .then((storage) => {token = storage.getString('token')});
    tDio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      HttpHeaders.connectionHeader: 'keep-alive',
      HttpHeaders.contentTypeHeader: 'application/json',
      'token': token
    };
    return tDio;
  }
}
