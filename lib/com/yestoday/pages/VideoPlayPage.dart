import 'package:flutter/cupertino.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

import 'config/Font.dart';

class VideoPlayPage extends StatefulWidget{
  MediumVO medium;

  VideoPlayPage(this.medium);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayState(medium);
  }
}

class VideoPlayState extends State<VideoPlayPage>{
  MediumVO medium;
  bool isBuffering = true;
  VideoPlayState(this.medium);
  final FijkPlayer player = FijkPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: ZJ_AppBar(""),
      body:
        Container(
        child: Material(
          child: FijkView(
            player: player,
            cover: NetworkImage(medium.icon),
            color: Colors.black,
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (medium.width>medium.height) {
      player.enterFullScreen();
    }
    player.setDataSource(medium.url, autoPlay: true);
  }
  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}

class LoadingUI extends StatelessWidget {
  String imgUrl;

  LoadingUI(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: [
            ZJ_Image.network(imgUrl,fit:BoxFit.fill),
            Expanded(
              child: ZJ_Image.network(imgUrl,fit:BoxFit.fill),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "纵使沧海桑田，海枯石烂\n\n"
                          "我们依然可以在这里\"相见\"",
                      style: TextStyle(color: Colors.white,fontSize: FontSize.LARGE)),
                  Padding(padding:EdgeInsets.all(10.0)),
                  CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 3.0,),
                  Padding(padding:EdgeInsets.all(10.0)),
                  Text("加载中...", style: TextStyle(color: Colors.white,fontSize: FontSize.SMALL))
                ],
              )
            )

          ],
        ));
  }
}