import 'package:zaijian/com/yestoday/common/BaseConfig.dart';

class BaseRsp{
  bool success;
  String msg;

  static BaseRsp FAIL = BaseRsp(false, BaseConfig.REQUEST_SERVER_ERROR);

  BaseRsp(bool bool, String msg);
}