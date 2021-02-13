import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';

/**
 * 登陆注册服务器接口操作类
 * 带login路径的请求都不需要携带token
 */
class LoginApi {
  static const String POST_LOGIN_PC = '/login/phoneCode';
  static const String POST_SIGNUP = '/login/signup';
  static const String POST_SEND_SMS = '/sms/send';


  static Future<dynamic> login(String phone, String code) async {
    try {
      Response response = await DioFactory.defaultDio().post(
          BaseConfig.HOST + POST_LOGIN_PC,
          data: {'phone': phone, 'code': code});
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }

  // 注册
  static Future<dynamic> signup(String phone, String code) async {
    try {
      Response response = await DioFactory.defaultDio().post(
          BaseConfig.HOST + POST_SIGNUP,
          data: {'phone': phone, 'code': code});
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }

  // 注册
  static Future<dynamic> sendSms(String phone) async {
    try {
      Response response = await DioFactory.defaultDio().post(BaseConfig.HOST + POST_SEND_SMS,
          data: {'phone': phone});
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }
}

class LoginRsp {
  bool success;
  String msg;
  String token;
  UserDTO user;

  LoginRsp(this.success, this.msg, this.token);
}

class UserDTO {
  String id;
  String nickName; // 昵称
  String phone;
  int sex; // 1：男   0 ：女   2：秘密
  String birthDay;
  String icon; // base64Encode(List<int> bytes)
  String vip;
}
