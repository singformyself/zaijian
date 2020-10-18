import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:video_player/video_player.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

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
  VideoPlayerController _controller;
  MediumDetailState(this.medium);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar(""),
      body: Material(
        child:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  //fit:StackFit.expand,
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio:medium.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row(//播放按钮，时长，进度条，倍速，全屏
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(_controller.value.isPlaying?Icons.play_arrow:Icons.pause,color: Colors.white),
                            onPressed: (){
                                this.setState(() {
                                  _controller.value.isPlaying?_controller.pause():_controller.play();
                                  print(_controller.value.aspectRatio);
                                });
                            },
                          ),
                          Text(getDuration(),style:TextStyle(color:Colors.white,fontSize: FontSize.SUPER_SMALL)),
                          Padding(padding: EdgeInsets.all(5.0)),
                          Expanded(
                            //width: 200.0,
                            child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding:EdgeInsets.all(0.0),
                                colors: VideoProgressColors(playedColor: Colors.blue),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(5.0)),
                          PopupMenuButton<double>(
                            initialValue: _controller.value.playbackSpeed,
                            padding:EdgeInsets.all(2.0),
                            color: Colors.black.withOpacity(0.5),
                            tooltip: '倍速',
                            onSelected: (speed) {
                              _controller.setPlaybackSpeed(speed);
                            },
                            itemBuilder: (context) {
                              return [
                                  PopupMenuItem(
                                    textStyle: TextStyle(fontSize: FontSize.NORMAL),
                                    value: 0.5,
                                    child: Text('0.5x'),
                                  ),
                                PopupMenuItem(
                                  textStyle: TextStyle(fontSize: FontSize.NORMAL),
                                  value: 1.0,
                                  child: Text('1.0x'),
                                ),
                                PopupMenuItem(
                                  textStyle: TextStyle(fontSize: FontSize.NORMAL),
                                  value: 1.5,
                                  child: Text('1.5x'),
                                ),
                                PopupMenuItem(
                                  textStyle: TextStyle(fontSize: FontSize.NORMAL),
                                  value: 2.0,
                                  child: Text('2.0x'),
                                ),
                              ];
                            },
                            child: Text(_controller.value.playbackSpeed.toString()+'x',style:TextStyle(color:Colors.white)),
                          ),
                          IconButton(
                              icon: Icon(Icons.fullscreen,color: Colors.white)
                          )
                        ],
                      ),
                    ),

//                      VideoPlayer(_controller),
//                      _ControlsOverlay(controller: _controller),
//                       VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(medium.url);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {
      _controller.setPlaybackSpeed(1.0);
      _controller.play();
    }));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getDuration() {
    String position = _controller.value.position.toString();
    String duration = _controller.value.duration.toString();
    return position.substring(0,position.lastIndexOf("."))+"/"+duration.substring(0,position.lastIndexOf("."));
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
