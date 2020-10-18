
import 'dart:math';

import 'package:zaijian/com/yestoday/model/MediumVO.dart';

import '../../../TestData.dart';

class MemoriesPageService {
  Future<List<MediumVO>> genMediumItems(String id) async {
    List<MediumVO> res = List();
    Random r = Random();
    for (int i = 0; i < 5; i++) {
      MediumEnum type = i % 2 == 0 ? MediumEnum.PHOTO : MediumEnum.VIDEO;
      res.add(MediumVO(
          "id",
          TestData.titles[r.nextInt(TestData.titles.length)],
          TestData.images[r.nextInt(TestData.images.length)],
          'https://zaijian.obs.cn-north-4.myhuaweicloud.com/3ad13a13a27bc2a951e68e91ecc1f60a.mp4',
          type,
          TestData.images[r.nextInt(TestData.images.length)],
          TestData.userNames[r.nextInt(TestData.userNames.length)],
          "2020-10-01"
      ));
    }
    return res;
  }
}
