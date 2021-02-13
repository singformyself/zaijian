import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/api/LoginApi.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';

class UserApi {
  static const String POST_UPDATE_INFO = "/user/updateInfo"; // 跟新用户基本信息
  static const String POST_CHANGE_PHONE = "/user/changePhone"; // 修改绑定手机

  static Future<dynamic> updateInfo(UpdateInfoReq req) async {
    try {
      Response response = await DioFactory.tokenDio()
          .post(BaseConfig.HOST + POST_UPDATE_INFO, data: req.toJson());
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }

  static Future<dynamic> changePhone(String uid, String phone, String code) async {
    try {
      Response response = await DioFactory.tokenDio().post(
          BaseConfig.HOST + POST_CHANGE_PHONE,
          data: {'uid': uid, 'phone': phone, 'code': code});
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }
}

class UpdateInfoReq {
  String uid;
  String nickName; // 昵称
  int sex; // 1：男   0 ：女   2：秘密
  String birthDay;

  UpdateInfoReq(this.uid, this.nickName, this.sex, this.birthDay);

  dynamic toJson() {
    return {'uid': uid, 'nickName': nickName, 'sex': sex, 'birthDay': birthDay};
  }
}

class UpdateInfoRsp {
  bool success;
  String msg;
  UserDTO user;

  static UpdateInfoRsp FAIL =
      UpdateInfoRsp(false, BaseConfig.REQUEST_SERVER_ERROR);

  UpdateInfoRsp(bool success, String msg);
}
