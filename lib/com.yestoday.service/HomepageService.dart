import 'package:flutter/material.dart';
import 'package:zaijian/com.yestoday.model/AnnouncementVO.dart';
import 'package:zaijian/com.yestoday.model/MediumVO.dart';
import 'package:zaijian/com.yestoday.model/MyFocusVO.dart';
import 'dart:math';

import '../TestData.dart';

class HomepageService {
  Future<List<AnnouncementVO>> getAnnouncements() async {
    List<AnnouncementVO> res = [];
    for (int i = 0; i < 3; i++) {
      res.add(AnnouncementVO("id", TestData.images[Random().nextInt(TestData.images.length)]));
    }
    return res;
  }

  Future<List<MyFocusVO>> getMyFocus(String userId) async {
    List<MyFocusVO> myFocus = List();
    Random r = Random();
    for (int i = 0; i < 5; i++) {
      myFocus.add(MyFocusVO(
          "id",
          TestData.titles[r.nextInt(TestData.titles.length)],
          genShowItems(1+r.nextInt(3)),
          TestData.images[r.nextInt(TestData.images.length)],
          TestData.userNames[r.nextInt(TestData.userNames.length)],
          "2016-12-05",
          "2020-10.01"));
    }
    return myFocus;
  }

  List<MediumVO> genShowItems(int max) {
    List<MediumVO> res = List();
    Random r = Random();
    for (int i = 0; i < max; i++) {
      MediumEnum type = i % 2 == 0 ? MediumEnum.PHOTO : MediumEnum.VIDEO;
      res.add(MediumVO("id", TestData.images[r.nextInt(TestData.images.length)], type));
    }
    return res;
  }
}
