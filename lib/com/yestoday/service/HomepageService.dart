import 'dart:math';
import 'package:zaijian/com/yestoday/model/AnnouncementVO.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/model/MyFocusVO.dart';
import '../../../TestData.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
class HomepageService {
  Future<List<AnnouncementVO>> getAnnouncements() async {
    List<AnnouncementVO> res = [];
    for (int i = 0; i < 3; i++) {
      res.add(AnnouncementVO(
          "id",
          TestData.images[Random().nextInt(TestData.images.length)],
          TestData.videos[Random().nextInt(TestData.videos.length)],
          MediumEnum.VIDEO
      )
      );
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
          TestData.images[r.nextInt(TestData.images.length)],
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
      int index = r.nextInt(TestData.videos.length);
      res.add(MediumVO(
          "id",
          TestData.titles[r.nextInt(TestData.titles.length)],
          TestData.images[r.nextInt(TestData.images.length)],
          TestData.videos[index],
          TestData.ratio[index][0],
          TestData.ratio[index][1],
          type,
          TestData.images[r.nextInt(TestData.images.length)],
          TestData.userNames[r.nextInt(TestData.userNames.length)],
          "2020-10-01",
          TestData.getPhotos(r.nextInt(20))
      ));
    }
    return res;
  }
}
