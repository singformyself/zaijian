import 'dart:math';

import 'com/yestoday/model/UserVO.dart';

class TestData {
  static final List<String> images = [
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/iouutyrtyt.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/fgdsg.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/iuyouytuyit.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/jkkjhlkjhlkj.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/jnhkmjngfdg.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/fdgfdgh.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/123456789.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/gfgfdhggjgf0.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/kjhjhhgfsgg.jpg",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/kjlhfghfdsdfdgf.jpg"
  ];

  static final List<String> userNames = [
    "再见Atlantis",
    "很傻很天真",
    "无悔的青春"
  ];

  static final List<String> titles = [
    "记录一次国外旅行,东方时空的健康乐观看法来决定是否记得给的开始JFK大师傅但是",
    "今年的春天，应该记录下来，待来年再见",
    "一起祝福祖国！国庆升旗仪式在天安门广场举行",
    "超拉风！木工爷爷为孙子手制礼炮车",
    "阿塞拜疆摧毁亚美尼亚8台“冰雹”火箭炮 行动录像曝光"
  ];

  static final List<String> videos = [
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/bcc7f2147c4fc6dccb256a46776bc2c7.mp4",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/3ad13a13a27bc2a951e68e91ecc1f60a.mp4",
    "https://zaijian.obs.cn-north-4.myhuaweicloud.com/video/2021-02/2bc6875f54064c319064ddba4d60f207.mp4"
  ];
  static final List<List<double>> ratio = [
    [960.0,544.0],
    [544.0,960.0],
    [544.0,960.0],
  ];

  static List<String> getPhotos(int max) {
    if (max==0) {
      max=5;
    }
    Random r = Random();
    List<String> res=[];
    for(int i=0;i<max;i++) {
      res.add(TestData.images[r.nextInt(TestData.images.length)]);
    }
    return res;
  }

  static UserVO getUser(String id){
    Random r = Random();
    return UserVO(id, userNames[r.nextInt(userNames.length)], "neal", images[r.nextInt(images.length)], "17767209594", "450721198702104438", "singformyself@yeah.net", "vip");
  }
}