
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

class PhotoSwiperPage extends StatelessWidget {
  MediumVO medium;
  int index;
  PhotoSwiperPage(this.medium,this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Swiper(
          autoplay: false,
          index: index,
          itemBuilder: (context, index) {
            return ZJ_Image.network(medium.photos[index],fit: BoxFit.contain);
          },
          itemCount: medium.photos.length,
          pagination: FractionPaginationBuilder(activeColor:Colors.white,fontSize: FontSize.LARGE,activeFontSize: FontSize.SUPER_LARGE)),
    );
  }
}