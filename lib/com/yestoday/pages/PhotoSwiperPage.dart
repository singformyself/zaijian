
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
typedef DoubleClickAnimationListener = void Function();
class PhotoSwiperPage extends StatefulWidget {
  MediumVO medium;
  int index;

  PhotoSwiperPage(this.medium, this.index);

  @override
  State<StatefulWidget> createState() {
    return PhotoSwiperPageState(medium,index);
  }

}
class PhotoSwiperPageState extends State<PhotoSwiperPage> with TickerProviderStateMixin {
  MediumVO medium;
  int index;
  AnimationController _doubleClickAnimationController;
  Animation<double> _doubleClickAnimation;
  DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  PhotoSwiperPageState(this.medium,this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar(""),
      backgroundColor: Colors.black,
      body: Swiper(
          autoplay: false,
          index: index,
          itemBuilder: (context, index) {
            return ExtendedImage.network(
              medium.photos[index],
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: 0.9,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: false,
                  initialAlignment: InitialAlignment.center,
                );
              },
                onDoubleTap: (ExtendedImageGestureState state) {
                  ///you can use define pointerDownPosition as you can,
                  ///default value is double tap pointer down postion.
                  var pointerDownPosition = state.pointerDownPosition;
                  double begin = state.gestureDetails.totalScale;
                  double end;

                  //remove old
                  _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

                  //stop pre
                  _doubleClickAnimationController.stop();

                  //reset to use
                  _doubleClickAnimationController.reset();

                  if (begin == doubleTapScales[0]) {
                    end = doubleTapScales[1];
                  } else {
                    end = doubleTapScales[0];
                  }

                  _doubleClickAnimationListener = () {
                    //print(_animation.value);
                    state.handleDoubleTap(
                        scale: _doubleClickAnimation.value,
                        doubleTapPosition: pointerDownPosition);
                  };
                  _doubleClickAnimation = _doubleClickAnimationController
                      .drive(Tween<double>(begin: begin, end: end));

                  _doubleClickAnimation.addListener(_doubleClickAnimationListener);

                  _doubleClickAnimationController.forward();
                }
            );
          },
          itemCount: medium.photos.length,
          pagination: FractionPaginationBuilder(activeColor:Colors.white,fontSize: 18,activeFontSize: 25.0)),
    );
  }

  @override
  void initState() {
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();
    super.dispose();
  }
}