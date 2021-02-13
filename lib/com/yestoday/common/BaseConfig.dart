/**
 * 项目基础配置类
 */
class BaseConfig {
  /*服务器地址*/
  static const String HOST = "http://192.168.145.103:80";
  static const String REQUEST_SERVER_ERROR = "请求服务器异常";
  static var COMMON_FAIL = {'success':false,'msg':BaseConfig.REQUEST_SERVER_ERROR};
  static RegExp phoneExp = RegExp(r'^1[3|4|5|6|7|8|9][0-9]{9}$');
}
class MyKeys{
  static const String TOKEN = "token";
  static const String USER = "user";
  static const String USER_ID = "id";
  static const String SUCCESS = "success";
  static const String MSG = "msg";
}
enum MediumEnum {
  VIDEO, PHOTO, PICTURE
}
