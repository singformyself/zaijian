/**
 * 项目基础配置类
 */
class BaseConfig {
  /*服务器地址*/
  static const String HOST = "http://192.168.145.103:80";
  static const String OBS_HOST = "https://zaijian.obs.cn-north-4.myhuaweicloud.com";
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
class Vip{
  static const String NORMAL ="普通会员";
  static const String GOLD ="黄金会员";
  static const String DIAMOND ="钻石会员";
  static const String LIFTLONG ="终生会员";

  static String getVip(int v){
    switch(v){
      case 0:return NORMAL;
      case 1:return GOLD;
      case 2:return DIAMOND;
      case 3:return LIFTLONG;
      default: return NORMAL;
    }
  }
}

class Sex{
  static const String GIRL ="女";
  static const String BOY ="男";
  static const String OTHER ="秘密";
  static String getSex(int v){
    switch(v){
      case 0:return GIRL;
      case 1:return BOY;
      case 2:return OTHER;
      default: return OTHER;
    }
  }
}
