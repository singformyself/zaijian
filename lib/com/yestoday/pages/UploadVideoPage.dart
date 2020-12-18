import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class UploadVideoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UploadVideoState();
  }
}

class UploadVideoState extends State<UploadVideoPage>{
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  File video;
  final ImagePicker imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传视频"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          // TODO submit
        },
      ),
      body:Form(
        key:formKey1,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入回忆名称";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.camera),
                  hintText: '编辑回忆名称',
                ),
              ),
            ),
            Container(
              //padding: EdgeInsets.all(10.0),
              child: OutlineButton(
                  child: PopupMenuButton<String>(
                      initialValue: "fromCamera",
                      padding: EdgeInsets.all(2.0),
                      tooltip: '选择视频',
                      onSelected: (value) {
                        if (value == "fromCamera") {
                          imagePicker
                              .getVideo(
                              source: ImageSource.camera)
                              .then((value) => this.setState(() {
                            video = File(value.path);
                          }));
                        } else {
                          imagePicker
                              .getVideo(
                              source: ImageSource.gallery)
                              .then((value) => this.setState(() {
                            video = File(value.path);
                          }));
                        }
                      },
                      child: Text("选择视频",style:TextStyle(color: Theme.of(context).primaryColor)),
                      itemBuilder: (context) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: "fromCamera",
                          child: Row(
                            children: [Icon(Icons.camera), Text("拍摄上传")],
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
              padding:EdgeInsets.all(10),
              child: video==null?Text("未选择任何视频"):Image.file(video),
            )
          ],
        ),
      ),
    );
  }
}