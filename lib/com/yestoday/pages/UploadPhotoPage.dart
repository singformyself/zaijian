import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class UploadPhotoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UploadPhotoState();
  }
}

class UploadPhotoState extends State<UploadPhotoPage>{
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传照片"),
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
          ],
        ),
      ),
    );
  }
}