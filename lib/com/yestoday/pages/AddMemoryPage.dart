import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaijian/com/yestoday/utils/Msg.dart';
import 'config/Font.dart';

class AddMemoryPage extends StatefulWidget {
  dynamic memory;

  AddMemoryPage({this.memory});

  @override
  State<StatefulWidget> createState() {
    return AddMemoryState(memory: memory);
  }
}

class AddMemoryState extends State<AddMemoryPage> {
  dynamic memory;

  AddMemoryState({this.memory});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  bool openValue = true;
  File image;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar(memory != null ? "修改主题" : "创建主题"),
      floatingActionButton: FloatingActionButton(
          child: Text("确定"),
          onPressed: () {
            submit(nameController.text, context);
          }),
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  maxLines: 2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "请输入主题名称";
                    }
                    if (value.length > 128) {
                      return "主题名称不能超过128个字符";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.camera),
                    hintText: '请输入主题名称',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("可见状态", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<bool>(
                      value: true,
                      groupValue: openValue,
                      onChanged: (value) {
                        this.setState(() {
                          openValue = value;
                        });
                      },
                    ),
                    Text("公开", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<bool>(
                      value: false,
                      groupValue: openValue,
                      onChanged: (value) {
                        this.setState(() {
                          openValue = value;
                        });
                      },
                    ),
                    Text("私有", style: TextStyle(fontSize: FontSize.NORMAL)),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.all(10.0),
                child: OutlineButton(
                    child: PopupMenuButton<String>(
                        initialValue: "fromCamera",
                        padding: EdgeInsets.all(2.0),
                        tooltip: '设置封面',
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
                        child: Text("设置封面",
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
                                  children: [Icon(Icons.photo), Text("从相册选择")],
                                ),
                              )
                            ])),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(40, 0.0, 40, 0.0),
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child:
                                  ExtendedImage.file(image, fit: BoxFit.cover))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: ExtendedImage.asset("assets/default.jpg",
                                  fit: BoxFit.cover))))
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: memory != null ? memory['title'] : '');
    openValue=memory != null ? memory['publicity'] : true;
  }

  Future<void> submit(String text, BuildContext context) async {
    // 优先上传图片到obs，图片上传成功，返回路径名称，再存储数据到服务器
    SharedPreferences stg = await SharedPreferences.getInstance();
    String uid = stg.get(KEY.USER_ID);
    dynamic data = {
      'id': memory != null ? memory['id'] : '',
      'title': nameController.text,
      'publicity': openValue,
      'creator': uid,
      'icon': ''
    };
    MemoryApi.save(data).then((rsp) async {
      if (rsp[KEY.SUCCESS]) {
        Msg.tip(memory != null ? "修改成功" : "创建成功", context);
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context, true);
      } else {
        Msg.alert(rsp[KEY.MSG], context);
      }
    });
  }
}
