import 'dart:math';

import 'package:zaijian/TestData.dart';
import 'package:zaijian/com/yestoday/model/MemoryVO.dart';

class MemoryManagerPageService {

  Future<List<MemoryVO>> getMemories(String userId) async {
    List<MemoryVO> list = [];
    Random r = Random();
     for(int i=0;i<3;i++){
      list.add(MemoryVO(
          "id",
          TestData.images[r.nextInt(TestData.images.length)],
          TestData.titles[r.nextInt(TestData.titles.length)],
          "2020-10-01",
          TestData.userNames[r.nextInt(TestData.userNames.length)],
          TestData.images[r.nextInt(TestData.images.length)]
      ));
    }
    return list;
  }
}