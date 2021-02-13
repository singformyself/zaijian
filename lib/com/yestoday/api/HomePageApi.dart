import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';
import 'package:zaijian/com/yestoday/common/BaseRsp.dart';

class HomePageApi {
  // 获取首页公告
  static const String GET_ANNOUNCEMENT = '/home/announcement';

  // 获取关注列表
  static const String GET_INTERESTS = '/home/interests';

  static Future<dynamic> getAnnouncement() async {
    try {
      Response response =
          await DioFactory.defaultDio().get(BaseConfig.HOST + GET_ANNOUNCEMENT);
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }

  // 获取我的关注信息
  static Future<dynamic> getInterests(String uid) async {
    try {
      Response response = await DioFactory.tokenDio()
          .get(BaseConfig.HOST + GET_INTERESTS + '?uid=' + uid);
      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      }
    } catch (e) {
      print(e);
    }
    return BaseConfig.COMMON_FAIL;
  }
}

class InterestsRsp extends BaseRsp {
  InterestsRsp(bool bool, String msg) : super(bool, msg);
  List<InterestsDTO> data;
}

/**
 * 我的关注实体
 */
class InterestsDTO {
  String id;
  String title;
  String icon;
  List<MediumDTO> showItems; // 显示的图
  String userIcon;
  String userNickName;
  String strDate;
  String endDate;
}
// 媒体对象
class MediumDTO {
  String id;
  String title;
  String icon;
  String url;
  double width;
  double height;
  MediumEnum type;
  String creatorIcon;
  String creator;
  String date;
  List<String> photos;
}

class AnnouncementRsp extends BaseRsp {
  AnnouncementRsp(bool bool, String msg) : super(bool, msg);
  List<AnnouncementDTO> data;
}

// 公告通过打开网页的方式实现，方便公告调整
class AnnouncementDTO {
  String icon;
  String url;
}
