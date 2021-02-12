import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
/**
 * 首页公告栏实体对象
 */
class AnnouncementVO {

  String id;
  String icon;
  String url;
  MediumEnum type;

  AnnouncementVO(this.id, this.icon, this.url, this.type);
}