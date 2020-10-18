import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:video_player/video_player.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_VideoPlayer.dart';

class MediumDetailPage extends StatefulWidget {
  MediumVO medium;

  MediumDetailPage(this.medium);

  @override
  State<StatefulWidget> createState() {
    return MediumDetailState(medium);
  }
}

class MediumDetailState extends State<MediumDetailPage> {
  MediumVO medium;
//  VideoPlayerController _controller;
  MediumDetailState(this.medium);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: ZJ_AppBar(""),
      body: Material(
        child:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
                ZJ_videoPlayer(medium.url,medium.aspectRatio),
            ],
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
