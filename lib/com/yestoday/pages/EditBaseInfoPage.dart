import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class EditBaseInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EditBaseInfoState();
  }
}

class EditBaseInfoState extends State<EditBaseInfoPage>{
  TextEditingController unameController = TextEditingController(text: "很傻很天真");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("编辑个人信息"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          // TODO submit
        },
      ),
      body: Form(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Row(
                children: [
                  Text("昵称："),
                  Expanded(child: TextFormField(
                    autofocus: false,
                    controller: unameController,
                  )),
                ],
              ),
              Row(
                children: [
                  Text("性别："),
                  Text("男"),
                  Radio(
                    value: "男",
                    groupValue: "性别",
                  ),
                  Text("女"),
                  Radio(
                    value: "女",
                    groupValue: "性别",
                  ),
                ],
              ),
              Row(
                children: [
                  Text("生日："),
                  // Expanded(child: DateTime),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}