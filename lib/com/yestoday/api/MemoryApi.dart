import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';

class MemoryApi {
  static const String POST_CREATE = "/memory/create";
  static const String GET_PAGE_LIST = "/memory/pageList";

  static Future<dynamic> create(dynamic data) async {
    try {
      Dio dio = await DioFactory.tokenDio();
      Response response =
          await dio.post(BaseConfig.HOST + POST_CREATE, data: data);
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }

  static Future<dynamic> pageList(String uid, int curPage, int length) async {
    try {
      Dio dio = await DioFactory.tokenDio();
      Response response = await dio.get(BaseConfig.HOST + GET_PAGE_LIST,
          queryParameters: {'uid': uid, 'curPage': curPage, 'length': length});
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }
}
