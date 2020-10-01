import 'package:flutter/material.dart';
import 'package:zaijian/com.yestoday.model/AnnouncementVO.dart';
import 'package:zaijian/com.yestoday.model/MediumVO.dart';
import 'package:zaijian/com.yestoday.model/MyFocusVO.dart';
import 'dart:math';

class HomepageService {
  List<String> images = [
    "https://bpic.588ku.com//back_origin_min_pic/20/09/09/0c90b733eb43503e421474ae80d1e796.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/09/23/14ea558abb484b54929f3a0414810d64.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/09/23/0fc674ba434e74609f9faaf9034cd005.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/20/08/21/dfe8bb55f5915c357d938f82d4876675.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/09/30/23bb6d35570c942d50f82d9d59d6ae6f.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/10/22/34743f7d6d0499460be0d62ad8f183ed.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/20/08/24/ba7aa0ff9b6f14451094fbb16859ca56.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/09/23/e57190b37017e4545c8e0b1b2196c480.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/19/10/22/79309612545d79d56a2c3baec885fef4.jpg!/fw/750/quality/99/unsharp/true/compress/true",
    "https://bpic.588ku.com//back_origin_min_pic/20/09/27/dcc36d1d47429025b80252e2a831b07f.jpg!/fw/750/quality/99/unsharp/true/compress/true"
  ];
  List<String> userNickNames = [
    "再见Atlantis",
    "很傻很天真",
  ];
  List<String> titles = [
    "记录一次国外旅行,东方时空的健康乐观看法来决定是否记得给的开始JFK大师傅但是",
    "今年的春天，应该记录下来，待来年再见",
    "一起祝福祖国！国庆升旗仪式在天安门广场举行",
    "超拉风！木工爷爷为孙子手制礼炮车",
    "阿塞拜疆摧毁亚美尼亚8台“冰雹”火箭炮 行动录像曝光"
  ];

  Future<List<AnnouncementVO>> getAnnouncements() async {
    List<AnnouncementVO> res = [];
    for (int i = 0; i < 3; i++) {
      res.add(AnnouncementVO("id", images[Random().nextInt(images.length)]));
    }
    return res;
  }

  Future<List<MyFocusVO>> getMyFocus(String userId) async {
    List<MyFocusVO> myFocus = List();
    Random r = Random();
    for (int i = 0; i < 5; i++) {
      myFocus.add(MyFocusVO(
          "id",
          titles[r.nextInt(titles.length)],
          genShowItems(1+r.nextInt(3)),
          images[r.nextInt(images.length)],
          userNickNames[r.nextInt(userNickNames.length)],
          "2016-12-05",
          "2020-10.01"));
    }
    print(myFocus);
    return myFocus;
  }

  List<MediumVO> genShowItems(int max) {
    List<MediumVO> res = List();
    Random r = Random();
    for (int i = 0; i < max; i++) {
      MediumEnum type = i % 2 == 0 ? MediumEnum.PHOTO : MediumEnum.VIDEO;
      res.add(MediumVO("id", images[r.nextInt(images.length)], type));
    }
    return res;
  }
}
