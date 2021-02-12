
import 'dart:math';

import 'package:zaijian/com/yestoday/model/MediumVO.dart';

import '../../../TestData.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
class MemoriesPageService {
  Future<List<MediumVO>> genMediumItems(String id) async {
    List<MediumVO> res = List();
    Random r = Random();
    for (int i = 0; i < 5; i++) {
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
