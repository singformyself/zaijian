import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';

class EditBaseInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EditBaseInfoState();
  }
}

class EditBaseInfoState extends State<EditBaseInfoPage>{
  String sex="男";
  String birthDay = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
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
                  Radio(
                    value: "男",
                    groupValue: sex,
                    onChanged: (value){
                      this.setState(() {
                        this.sex=value;
                      });
                    },
                  ),
                  Text("男"),
                  Radio(
                    value: "女",
                    groupValue: sex,
                    onChanged: (value){
                      this.setState(() {
                        this.sex=value;
                      });
                    },
                  ),
                  Text("女"),
                  Radio(
                    value: "秘密",
                    groupValue: sex,
                    onChanged: (value){
                      this.setState(() {
                        this.sex=value;
                      });
                    },
                  ),
                  Text("秘密"),
                ],
              ),
              Row(
                children: [
                  Text("生日："),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(birthDay,style: TextStyle(color:Theme.of(context).primaryColor,fontSize: FontSize.NORMAL)),
                    onPressed: (){
                      MyPicker.showPicker(
                        context: context,
                        current: DateTime.now(),
                        mode: MyPickerMode.date,
                        onConfirm: (val)=>{
                          this.setState(() {
                            birthDay=formatDate(val, [yyyy, '-', mm, '-', dd]);;
                          })
                        },
                      );
                    },
                  ),
                  // Expanded(child: DateTime),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    birthDay = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  }
}