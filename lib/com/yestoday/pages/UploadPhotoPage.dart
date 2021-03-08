import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/service/MyTask.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

class UploadPhotoPage extends StatefulWidget {
  dynamic memory;

  UploadPhotoPage(this.memory);

  @override
  State<StatefulWidget> createState() {
    return UploadPhotoState(memory);
  }
}

class UploadPhotoState extends State<UploadPhotoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  dynamic memory;

  UploadPhotoState(this.memory);

  List<PlatformFile> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传照片"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          submit();
        },
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                  icon: Icon(Icons.camera),
                  hintText: '起个名吧',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("已选（最多可选30）："),
                  Text(images.length.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: FontSize.LARGE)),
                  Padding(padding: EdgeInsets.all(5)),
                  OutlinedButton(
                    child: Text("选择照片",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: loadAssets,
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: buildGridView(),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(images.length, (index) {
        File file = File(images[index].path);
        return Container(
            padding: EdgeInsets.all(0.5),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Image.file(file, width: 150, height: 150, fit: BoxFit.cover),
                IconButton(
                  padding: EdgeInsets.all(0.5),
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.remove_circle, color: Colors.white),
                  onPressed: () => {
                    this.setState(() {
                      images.removeAt(index);
                    })
                  },
                )
              ],
            ));
      }),
    );
  }

  Future<void> loadAssets() async {
    FilePicker.platform
        .pickFiles(
            allowMultiple: true,
            type: FileType.image,
            onFileLoading: (st) {
              if (st == FilePickerStatus.picking) {
                EasyLoading.show(status: "加载中...");
              } else {
                EasyLoading.dismiss();
              }
            })
        .then((result) {
      if (result != null) {
        if (result.files.length > 30) {
          result.files.removeRange(30, result.files.length);
        }
        images = result.files;
        this.setState(() {});
      }
    });
//    try {
//      resultList = await MultiImagePicker.pickImages(
//        maxImages: 30,
//        enableCamera: true,
//        selectedAssets: images,
//        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//        materialOptions: MaterialOptions(
//          statusBarColor: "#2196f3",
//          actionBarColor: "#2196f3",
//          actionBarTitle: "选择照片",
//          allViewTitle: "全部照片",
//          useDetailsView: false,
//          selectCircleStrokeColor: "#FFFFFF",
//        ),
//      );
//    } on Exception catch (e) {
//      error = e.toString();
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      images = resultList;
//      _error = error;
//    });
  }

  Future<void> submit() async {
    if (images.length == 0) {
      EasyLoading.showInfo("请选择要上传的照片");
      return;
    }
    if (!formKey.currentState.validate()) {
      return;
    }
    // 获取缩略图,拿第一张照片
    Uint8List compData = await compressCover(images[0]);
    // 优先上传图片到obs，图片上传成功，返回路径名称，再存储数据到服务器
    String icon = MyUtil.genCoverName();
    bool success = await OBSApi.uploadObsBytes(icon, compData);
    if (!success) {
      EasyLoading.showError('初始化封面失败，请重试');
      return;
    }
    // 循环所有图片，计算总大小
    int totalBytes = 0;
    List<String> urls = [];
    List<String> paths = [];
    List<String> obIds = [];
    for (int i = 0; i < images.length; i++) {
      totalBytes += images[i].size;
      String path = images[i].path;
      paths.add(path);
      String url = MyUtil.genPhotoName(path);
      obIds.add(url);
      urls.add('/' + url);
    }
    // 上传视频objectId
    var data = {
      'mid': memory['id'],
      'creator': await MyUtil.getUserId(),
      'title': nameController.text,
      'type': 1, //照片
      'icon': '/' + icon,
      'urls': urls,
      'fileBytes': totalBytes
    };
    dynamic rsp = await MemoryApi.putJson(MemoryApi.PUT_MEMORY_ITEM, data);
    if (!rsp[KEY.SUCCESS]) {
      EasyLoading.showError(rsp[KEY.MSG]);
      return;
    }
    // 构建上传任务
    List<UploadObject> obs = [];
    for (int i = 0; i < obIds.length; i++) {
      obs.add(UploadObject(obIds[i], paths[i]));
    }
    UploadTask task = UploadTask.name(1,rsp['itemId'], obs, totalBytes);
    MyTask.instance.addTask(task);
    EasyLoading.showSuccess('创建成功');
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.pop(context, true);
  }

  Future<Uint8List> compressCover(PlatformFile imag) async {
    File file = File(imag.path);
    Uint8List bytes = await file.readAsBytes();
    // 由于截图比较大，先压缩后上传
    Uint8List compData = await FlutterImageCompress.compressWithList(
      bytes,
      minHeight: 180,
      minWidth: 285,
      quality: 80,
    );
    return compData;
  }
}
