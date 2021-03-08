import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/service/MyTask.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadVideoPage extends StatefulWidget {
  dynamic memory;

  UploadVideoPage({this.memory});

  @override
  State<StatefulWidget> createState() {
    return UploadVideoState(this.memory);
  }
}

class UploadVideoState extends State<UploadVideoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  dynamic memory;
  UploadVideoState(this.memory);
  FijkPlayer player = FijkPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传视频"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          submit();
        },
      ),
      body: Form(
        key: formKey,
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
                  if (value.length > 128) {
                    return "名称不能超过128个字符";
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
                    child: player.dataSource == null
                        ? Center(child: Text("未选择文件"))
                        : Material(
                            child: FijkView(
                              fit: FijkFit.cover,
                              fs: false,
                              player: player,
                              panelBuilder: null, // 不提供操作界面
                              color: Colors.white,
                            ),
                          )),
                Padding(padding: EdgeInsets.all(10)),
                OutlinedButton(
                    child: Text("选择视频...",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      player.reset();
                      FilePicker.platform
                          .pickFiles(
                              type: FileType.video,
                              onFileLoading: (st) {
                                if (st == FilePickerStatus.picking) {
                                  EasyLoading.show(status: "加载中...");
                                } else {
                                  EasyLoading.dismiss();
                                }
                              })
                          .then((result) {
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
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  Future<void> submit() async {
    if (player.dataSource == null) {
      EasyLoading.showInfo("请选择要上传的视频");
      return;
    }
    if (!formKey.currentState.validate()) {
      return;
    }
    // 截图并压缩
    Uint8List compData = await takeSnapShotAndCompress();
    // 优先上传图片到obs，图片上传成功，返回路径名称，再存储数据到服务器
    String icon = MyUtil.genCoverName();
    bool success = await OBSApi.uploadObsBytes(icon, compData);
    if (!success) {
      EasyLoading.showError('初始化封面失败，请重试');
      return;
    }
    File uploadFile = File(player.dataSource);
    int totalBytes = uploadFile.lengthSync();
    // 上传视频objectId
    String videoName = MyUtil.genVideoName(player.dataSource);
    var data = {
      'mid': memory['id'],
      'creator': await MyUtil.getUserId(),
      'title': nameController.text,
      'type': 0, //视频
      'icon': '/' + icon,
      'urls':['/'+videoName],
      'fileBytes':totalBytes
    };
    dynamic rsp = await MemoryApi.putJson(MemoryApi.PUT_MEMORY_ITEM, data);
    if (!rsp[KEY.SUCCESS]) {
      EasyLoading.showError(rsp[KEY.MSG]);
      return;
    }
    // 构建上传任务
    UploadTask task = UploadTask.fromJson({
      'type':0,
      'itemId':rsp['itemId'],
      'uploadObjects':[{'objectId':videoName,'filePath':uploadFile.path}],
      'totalBytes':totalBytes
    });
    MyTask.instance.addTask(task);
    EasyLoading.showSuccess('创建成功');
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.pop(context, true);
  }

  Future<Uint8List> takeSnapShotAndCompress() async {
    Uint8List imageData = await player.takeSnapShot();
    // 由于截图比较大，先压缩后上传
    Uint8List compData = await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: 180,
      minWidth: 285,
      quality: 80,
      rotate: player.value.rotate,
    );
    return compData;
  }
}
