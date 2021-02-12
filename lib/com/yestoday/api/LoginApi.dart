import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';

/**
 * 登陆注册服务器接口操作类
 * 带login路径的请求都不需要携带token
 */
class LoginApi {
  static const String PATH_NP = "/login/byNamePassword";
  static const String PATH_PC = "/login/byPhoneCode";
  static const String SIGNUP = "/login/signup";

  static Future<LoginRsp> byNamePassword(String name, String password) async {
    try {
      Response response = await DioFactory.defaultDio().post(BaseConfig.HOST + PATH_NP,
          data: {"name": name, "password": password});
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return LoginRsp.FAIL;
  }

  static Future<LoginRsp> byPhoneCode(String phone, String code) async {
    try {
      Response response = await DioFactory.defaultDio().post(BaseConfig.HOST + PATH_PC,
          data: {"phone": phone, "code": code});
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return LoginRsp.FAIL;
  }

  // 注册
  static Future<LoginRsp> signup(String phone) async {
    try {
      Response response = await DioFactory.defaultDio().post(BaseConfig.HOST + SIGNUP,
          data: {"phone": phone});
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return LoginRsp.FAIL;
  }
}

class LoginRsp {
  // ignore: non_constant_identifier_names
  static LoginRsp FAIL = LoginRsp(false, BaseConfig.REQUEST_SERVER_ERROR, "");
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
  int sex;  // 1：男   0 ：女   2：秘密
  String birthDay;
  String icon; // base64Encode(List<int> bytes)
  String vip;
}
