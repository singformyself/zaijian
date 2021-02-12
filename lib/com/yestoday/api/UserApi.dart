import 'dart:convert';
import 'dart:html';
import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/api/LoginApi.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';
import 'package:zaijian/com/yestoday/common/BaseRsp.dart';

class UserApi {
  static const String PATH_UPDATE_INFO = "/user/updateInfo"; // 跟新用户基本信息
  static const String PATH_CHANGE_PWD = "/user/changePwd";  // 修改密码
  static const String PATH_CHANGE_PHONE = "/user/changePhone"; // 修改绑定手机

  static Future<UpdateInfoRsp> updateInfo(UpdateInfoReq req) async {
    try {
      Response response = await DioFactory.tokenDio()
          .post(BaseConfig.HOST + PATH_UPDATE_INFO, data: json.encode(req));
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return UpdateInfoRsp.FAIL;
  }

  static Future<BaseRsp> changePwd(String uid, String pwd) async {
    try {
      Response response = await DioFactory.tokenDio().post(
          BaseConfig.HOST + PATH_CHANGE_PWD,
          data: {'uid': uid, 'password': pwd});
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return BaseRsp.FAIL;
  }

  static Future<BaseRsp> changePhone(String uid, String phone, String code) async {
    try {
      Response response = await DioFactory.tokenDio().post(
          BaseConfig.HOST + PATH_CHANGE_PHONE,
          data: {'uid': uid, 'phone': phone, 'code': code});
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return BaseRsp.FAIL;
  }
}

class UpdateInfoReq {
  String id;
  String nickName; // 昵称
  int sex; // 1：男   0 ：女   2：秘密
  String birthDay;
}

class UpdateInfoRsp {
  bool success;
  String msg;
  UserDTO user;

  static UpdateInfoRsp FAIL =
      UpdateInfoRsp(false, BaseConfig.REQUEST_SERVER_ERROR);

  UpdateInfoRsp(bool success, String msg);
}
