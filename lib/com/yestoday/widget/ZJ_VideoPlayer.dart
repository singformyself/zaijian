import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';

class ZJ_videoPlayer extends StatefulWidget {
  String url;
  double aspectRatio;

  ZJ_videoPlayer(this.url, this.aspectRatio);

  @override
  State<StatefulWidget> createState() {
    return ZJ_VideoPlayerState(url, aspectRatio);
  }
}

class ZJ_VideoPlayerState extends State<ZJ_videoPlayer> {
  String url;
  double aspectRatio;

  ZJ_VideoPlayerState(this.url, this.aspectRatio);

  bool loading = true;
  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        //fit:StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        children:
        loading?[LoadingUI(aspectRatio)]:[
          AspectRatio(
            aspectRatio: aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Row(
              //播放按钮，时长，进度条，倍速，全屏
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.play_arrow
                          : Icons.pause,
                      color: Colors.white),
                  onPressed: () {
                    this.setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
                Text(getDuration(),
                    style: TextStyle(
                        color: Colors.white, fontSize: FontSize.SUPER_SMALL)),
                Padding(padding: EdgeInsets.all(5.0)),
                Expanded(
                  //width: 200.0,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: EdgeInsets.all(0.0),
                    colors: VideoProgressColors(playedColor: Colors.blue),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                PopupMenuButton<double>(
                  initialValue: _controller.value.playbackSpeed,
                  padding: EdgeInsets.all(2.0),
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
                  child: Text(getSpeedText(),
                      style: TextStyle(color: Colors.white)),
                ),
                IconButton(icon: Icon(Icons.fullscreen, color: Colors.white))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadingVideo();
  }

  void loadingVideo() {
    loading = true;
    _controller = VideoPlayerController.network(url);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {
          loading = false;
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
    return position.substring(0, position.lastIndexOf(".")) +
        "/" +
        duration.substring(0, position.lastIndexOf("."));
  }

  String getSpeedText() {
    return _controller.value.playbackSpeed.toString() + 'x';
  }
}

class LoadingUI extends StatelessWidget {
  double aspectRatio;

  LoadingUI(this.aspectRatio);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        child: AspectRatio(
          aspectRatio: aspectRatio,
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
          ),
        ));
  }
}
