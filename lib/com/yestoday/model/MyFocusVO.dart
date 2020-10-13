

import 'MediumVO.dart';

/**
 * 我的关注实体
 */
class MyFocusVO {
  String id;
  String title;
  String icon;
  List<MediumVO> showItems; // 显示的图
  String userIcon;
  String userNickName;
  String strDate;
  String endDate;

  MyFocusVO(this.id, this.title, this.icon, this.showItems, this.userIcon,
      this.userNickName, this.strDate, this.endDate);
}