import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';
import 'package:zaijian/com/yestoday/common/BaseRsp.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';

class HomePageApi {
  // 获取首页公告
  static const String GET_ANNOUNCEMENT = '/home/announcement';

  // 获取关注列表
  static const String GET_INTERESTS = '/home/interests';

  static Future<AnnouncementRsp> getAnnouncement() async {
    try {
      Response response =
          await DioFactory.defaultDio().get(BaseConfig.HOST + GET_ANNOUNCEMENT);
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return BaseRsp.FAIL;
  }

  // 获取我的关注信息
  static Future<InterestsRsp> getInterests(String uid) async {
    try {
      Response response = await DioFactory.tokenDio()
          .get(BaseConfig.HOST + GET_INTERESTS + '?uid=' + uid);
      if (response.statusCode == HttpStatus.ok) {
        return json.decode(response.data);
      }
    } catch (e) {
      print(e);
    }
    return BaseRsp.FAIL;
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

  MediumDTO(this.id, this.title, this.icon, this.url, this.width, this.height,
      this.type, this.creatorIcon, this.creator, this.date, this.photos);
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
