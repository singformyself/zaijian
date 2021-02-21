import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/widget/common_widget.dart';
import 'package:zaijian/com/yestoday/utils/crop_editor_helper.dart';

// ignore: must_be_immutable
class EditHeadIconPage extends StatefulWidget {
  dynamic user;

  EditHeadIconPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return EditHeadIconState(user);
  }
}

class EditHeadIconState extends State<EditHeadIconPage> {
  dynamic user;
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
        floatingActionButton: FloatingActionButton(
          child: Text("确定"),
          onPressed: () {
            submitData();
          },
        ),
        body: Column(
        children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("预览"),
                    Padding(padding: EdgeInsets.all(10)),
                    ClipOval(
                      child: cropImageDate != null
                          ? ExtendedImage.memory(cropImageDate,
                              width: 60, height: 60, fit: BoxFit.cover)
                          : ZJ_Image.network(
                              MyApi.OBS_HOST + user['icon'],
                              width: 90,
                              height: 90,
                            ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    PopupMenuButton<String>(
                        initialValue: "fromCamera",
                        padding: EdgeInsets.all(2.0),
                        tooltip: '选择图片',
                        onSelected: (value) {
                          imagePicker
                              .getImage(
                              source: value == "fromCamera"
                                  ? ImageSource.camera
                                  : ImageSource.gallery,
                              maxWidth: 800,
                              maxHeight: 800)
                              .then((value) {
                            if (value != null) {
                              this.setState(() {
                                image = File(value.path);
                              });
                            }
                          });
                        },
                        child: OutlinedButton(child: Text("选择图片...",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),),
                        itemBuilder: (context) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: "fromCamera",
                            child: Row(
                              children: [
                                Icon(Icons.camera),
                                Text("拍照上传")
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "fromGallery",
                            child: Row(
                              children: [
                                Icon(Icons.photo),
                                Text("从相册选择")
                              ],
                            ),
                          )
                        ]),
                  ],
                )),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text("裁剪区域"),
            ),
            Container(
              height: 300.0,
              color: Colors.black12,
              child: image != null
                  ? ExtendedImage.file(
                      image,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.editor,
                      enableLoadState: true,
                      extendedImageEditorKey: editorKey,
                      initEditorConfigHandler: (ExtendedImageState state) {
                        return EditorConfig(
                          maxScale: 8.0,
                          cropRectPadding: const EdgeInsets.all(20.0),
                          hitTestSize: 20.0,
                          initCropRectType: InitCropRectType.imageRect,
                          cropAspectRatio: CropAspectRatios.ratio4_3,
                        );
                      },
                    )
                  : ExtendedImage.network(
                      MyApi.OBS_HOST + user['icon'],
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.editor,
                      enableLoadState: true,
                      extendedImageEditorKey: editorKey,
                      initEditorConfigHandler: (ExtendedImageState state) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButtonWithIcon(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(Icons.rotate_left,
                      color: Theme.of(context).primaryColor),
                  label: Text("左旋",
                      style: TextStyle(
                          fontSize: FontSize.SUPER_SMALL,
                          color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    editorKey.currentState.rotate(right: false);
                  },
                ),
                FlatButtonWithIcon(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(Icons.rotate_right,
                      color: Theme.of(context).primaryColor),
                  label: Text("右旋",
                      style: TextStyle(
                          fontSize: FontSize.SUPER_SMALL,
                          color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    editorKey.currentState.rotate(right: true);
                  },
                ),
                FlatButtonWithIcon(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(Icons.restore,
                      color: Theme.of(context).primaryColor),
                  label: Text("重置",
                      style: TextStyle(
                          fontSize: FontSize.SUPER_SMALL,
                          color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    editorKey.currentState.reset();
                  },
                ),
                FlatButtonWithIcon(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: Icon(Icons.crop, color: Theme.of(context).primaryColor),
                  label: Text("剪裁",
                      style: TextStyle(
                          fontSize: FontSize.SUPER_SMALL,
                          color: Theme.of(context).primaryColor)),
                  onPressed: _cropImage,
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _cropImage() async {
    if (_cropping) {
      return;
    }
    String msg = '';
    try {
      _cropping = true;
      Uint8List fileData = Uint8List.fromList(
          await cropImageDataWithNativeLibrary(state: editorKey.currentState));
      this.setState(() {
        cropImageDate = fileData;
      });
    } catch (e, stack) {
      msg = '_cropImage failed: $e\n $stack';
      print(msg);
    } finally {
      _cropping = false;
    }
  }

  void submitData() async {
    if (cropImageDate == null) {
      await _cropImage();
    }
    String name = Uuid().v4() + ".jpg";
    bool success =
        await OBSApi.uploadObsBytes(name, cropImageDate);
    if (success) {
      dynamic rsp =await UserApi.updateIcon(user['id'], name);
      if (rsp[KEY.SUCCESS]) {
        EasyLoading.showSuccess('更新成功');
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.pop(context, rsp[KEY.USER]);
      } else {
        EasyLoading.showError('更新失败');
      }
    }
  }
}
