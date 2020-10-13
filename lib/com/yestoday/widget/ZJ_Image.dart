import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/**
 * 封装的ExtendedImage组件
 */
class ZJ_Image extends StatelessWidget {
  String url;
  double width;
  double height;
  Color color;
  BlendMode colorBlendMode;
  BoxFit fit;

  ZJ_Image.network(this.url,
      {this.width, this.height, this.color, this.colorBlendMode, this.fit});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit == null ? BoxFit.cover : fit,
      cache: true,
    );
  }
}
