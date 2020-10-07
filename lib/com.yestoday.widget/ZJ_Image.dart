import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

/**
 * 封装的ExtendedImage组件
 */
class ZJ_Image extends StatelessWidget {
  String url;
  double width;
  double height;

  ZJ_Image.network(this.url,{this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      cache: true,
    );
  }
}