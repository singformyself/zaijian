import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/model/UserVO.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/widget/common_widget.dart';

import 'config/Font.dart';

class EditHeadIconPage extends StatefulWidget {
  UserVO user;

  EditHeadIconPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return EditHeadIconState(user);
  }
}

class EditHeadIconState extends State<EditHeadIconPage> {
  UserVO user;
  File image;
  Uint8List cropImageDate;
  final ImagePicker imagePicker = ImagePicker();
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;
  EditHeadIconState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar("编辑头像"),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                Row(
                  children: [
                    Text("预览"),
                    Padding(padding: EdgeInsets.all(10)),
                    ClipOval(
                      child: cropImageDate != null
                          ? ExtendedImage.memory(
                              cropImageDate,
                              width: 90,
                              height: 90,
                              fit:BoxFit.cover
                            )
                          : ZJ_Image.network(
                              user.icon,
                              width: 90,
                              height: 90,
                            ),
                    ),
                  ],
                ),
                Container(
                  child: OutlineButton(
                    child: PopupMenuButton<String>(
                        initialValue: "fromCamera",
                        padding: EdgeInsets.all(2.0),
                        tooltip: '选择图片',
                        onSelected: (value) {
                          if (value == "fromCamera") {
                            imagePicker
                                .getImage(
                                    source: ImageSource.camera, maxWidth: 450)
                                .then((value) => this.setState(() {
                                      image = File(value.path);
                                    }));
                          } else {
                            imagePicker
                                .getImage(
                                    source: ImageSource.gallery, maxWidth: 450)
                                .then((value) => this.setState(() {
                                      image = File(value.path);
                                    }));
                          }
                        },
                        child: Text("选择图片",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        itemBuilder: (context) => <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                value: "fromCamera",
                                child: Row(
                                  children: [Icon(Icons.camera), Text("拍照上传")],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: "fromGallery",
                                child: Row(
                                  children: [Icon(Icons.camera), Text("从相册选择")],
                                ),
                              )
                            ]),
                  ),
                ),
                Row(children: [Text("裁剪区域")]),
                Container(
                  height:300.0,
                  color: Colors.black12,
                  child: image != null
                          ? ExtendedImage.file(
                              image,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.editor,
                              enableLoadState: true,
                              extendedImageEditorKey: editorKey,
                              initEditorConfigHandler:
                                  (ExtendedImageState state) {
                                return EditorConfig(
                                  maxScale: 8.0,
                                  cropRectPadding: const EdgeInsets.all(20.0),
                                  hitTestSize: 20.0,
                                  initCropRectType: InitCropRectType.imageRect,
                                  cropAspectRatio: CropAspectRatios.ratio4_3,
                                );
                              },
                            )
                          : ExtendedImage.asset(
                              "assets/default.jpg",
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.editor,
                              enableLoadState: true,
                              extendedImageEditorKey: editorKey,
                              initEditorConfigHandler:
                                  (ExtendedImageState state) {
                                return EditorConfig(
                                  maxScale: 8.0,
                                  cropRectPadding: const EdgeInsets.all(20.0),
                                  hitTestSize: 20.0,
                                  initCropRectType: InitCropRectType.imageRect,
                                  cropAspectRatio: CropAspectRatios.ratio4_3,
                                );
                              },
                            ),
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    FlatButtonWithIcon(
                      icon: const Icon(Icons.rotate_left),
                      label: const Text("左旋",style:TextStyle(fontSize: FontSize.SUPER_SMALL)),
                    ),
                    FlatButtonWithIcon(
                      icon: const Icon(Icons.rotate_right),
                      label: const Text("右旋",style:TextStyle(fontSize: FontSize.SUPER_SMALL)),
                    ),
                    FlatButtonWithIcon(
                      icon: const Icon(Icons.restore),
                      label: const Text("重置",style:TextStyle(fontSize: FontSize.SUPER_SMALL)),
                    ),
                    FlatButtonWithIcon(
                      icon: const Icon(Icons.crop),
                      label: const Text("剪裁",style:TextStyle(fontSize: FontSize.SUPER_SMALL)),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top:10.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    hoverColor: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text("确   定",
                        style: TextStyle(
                            color: Colors.white, fontSize: FontSize.LARGE)),
                    onPressed: () {
                      Toast.show("提交成功", context);
                    },
                  ),
                ),
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    this.setState(() {
      cropImageDate = editorKey.currentState.rawImageData;
    });
  }
}
