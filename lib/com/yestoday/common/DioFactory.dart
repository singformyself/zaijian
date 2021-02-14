import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioFactory {
  static Dio defDio;
  static Dio tDio;

  static Dio defaultDio() {
    if (defDio == null) {
      defDio = Dio();
      defDio.options.responseType = ResponseType.json;
      defDio.options.connectTimeout = 5000; //5s
      defDio.options.receiveTimeout = 5000;
      defDio.options.headers = {
        HttpHeaders.userAgentHeader: 'dio',
        HttpHeaders.connectionHeader: 'keep-alive',
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    }
    return defDio;
  }

  static Future<Dio> tokenDio() async {
    if (tDio == null) {
      tDio = Dio();
      tDio.options.responseType = ResponseType.json;
      tDio.options.connectTimeout = 5000; //5s
      tDio.options.receiveTimeout = 15000;
    }
    SharedPreferences stg = await SharedPreferences.getInstance();
    String token = stg.getString('token');
    tDio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      HttpHeaders.connectionHeader: 'keep-alive',
      HttpHeaders.contentTypeHeader: 'application/json',
      'token': token
    };
    return tDio;
  }
}
