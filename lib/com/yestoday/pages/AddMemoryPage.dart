import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:image_picker/image_picker.dart';

import 'config/Font.dart';

class AddMemoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddMemoryState();
  }
}

class AddMemoryState extends State<AddMemoryPage> {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String openValue;
  File image;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("新增主题"),
      body: Form(
          key: formKey1,
          child: Column(
            children: [
              Container(
                height: 50.0,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "请输入主题名称";
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("可见状态", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<String>(
                      value: "public",
                      groupValue: openValue,
                      onChanged: (value) {
                        this.setState(() {
                          openValue = value;
                        });
                      },
                    ),
                    Text("所有人可见", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<String>(
                      value: "private",
                      groupValue: openValue,
                      onChanged: (value) {
                        this.setState(() {
                          openValue = value;
                        });
                      },
                    ),
                    Text("仅自己可见", style: TextStyle(fontSize: FontSize.NORMAL)),
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
                        child: Text("设置封面",style:TextStyle(color: Theme.of(context).primaryColor)),
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
                                  fit: BoxFit.cover)))),
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(10.0),
                  height: 65.0,
                  child: SizedBox.expand(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      hoverColor: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("确    定",
                          style: TextStyle(
                              color: Colors.white, fontSize: FontSize.LARGE)),
                      onPressed: () {
                        if (formKey1.currentState.validate()) {
                          // 校验通过则可提交
                          // 通过unameController.text,upasswordController.text获取表单数据
                          Toast.show("提交成功", context);
                        }
                      },
                    ),
                  )),
            ],
          )),
    );
  }
}
