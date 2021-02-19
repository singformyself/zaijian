import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';

class UploadVideoPage extends StatefulWidget {
  dynamic memory;
  PickedFile pickedFile;

  UploadVideoPage({this.memory, this.pickedFile});

  @override
  State<StatefulWidget> createState() {
    return UploadVideoState(this.memory, this.pickedFile);
  }
}

class UploadVideoState extends State<UploadVideoPage> {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  PickedFile pickedFile;
  dynamic memory;
  Uint8List snapshotData;
//  final ImagePicker imagePicker = ImagePicker();

  UploadVideoState(this.memory, this.pickedFile);

  FijkPlayer player = FijkPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传视频"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          takeSnapShot();
        },
      ),
      body: Form(
        key: formKey1,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Icon(Icons.theaters),
                  title: Text(memory['title'],
                      style: TextStyle(fontSize: FontSize.NORMAL),
                      overflow: TextOverflow.clip),
                  trailing: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ZJ_Image.network(MyApi.OBS_HOST + memory['icon'],
                          width: 95.0, height: 60.0))),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                maxLines: 2,
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入回忆名称";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.drive_file_rename_outline),
                  hintText: '起个名吧',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(children: [
                Container(
                    width: 160,
                    height: 100,
                    child: player.dataSource==null?Center(child: Text("未选择文件")):Material(
                      child: FijkView(
                        fit: FijkFit.cover,
                        fs: false,
                        player: player,
                        panelBuilder: null,// 不提供操作界面
                        color: Colors.white,
                      ),
                    )),
                Padding(padding: EdgeInsets.all(10)),
                OutlineButton(
                    child: Text("选择视频...",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      player.reset();
                      FilePicker.platform.pickFiles(type: FileType.custom,
                          allowedExtensions: ['mp4', 'flv', 'wmv', 'avi'],
                      onFileLoading:(st){
                        if (st==FilePickerStatus.picking) {
                          EasyLoading.show(status: "加载中...");
                        } else {
                          EasyLoading.dismiss();
                        }
                      } ).then((result) {
                        if (result != null) {
                          player.setDataSource(result.files.single.path,
                              autoPlay: false, showCover: true);
                          this.setState(() {});
                        }
                      });
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    player.setOption(FijkOption.playerCategory, "cover-after-prepared", [0, 1]);
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  Future<void> takeSnapShot() async {
    if (player.dataSource==null) {
      EasyLoading.showInfo("请选择要上传的视频");
      return;
    }
    var imageData = await player.takeSnapShot();
    if (imageData != null) {
      print(imageData);
    }
    // 优先上传图片到obs，图片上传成功，返回路径名称，再存储数据到服务器
//    String month = formatDate(DateTime.now(), [yyyy, '-', mm]);
//    String name = "cover/" + month + "/" + Uuid().v4() + ".jpg";
//    bool success = await OBSApi.uploadObsBytes(name, imageData);
  }
}
