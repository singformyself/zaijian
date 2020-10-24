import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("新增主题"),
      body: Form(
        key: formKey1,
        child: Column(
          children: [
            Container(
              height:50.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType:TextInputType.phone,
                controller: nameController,
                maxLines:3,
                validator: (value) {
                  if(value.isEmpty) {
                    return "请输入手机号";
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
                  Text("可见状态",style:TextStyle(fontSize: FontSize.NORMAL)),
                  Radio<String>(
                    value: "public",
                    groupValue: openValue,
                    onChanged: (value){
                      this.setState(() {
                        openValue = value;
                      });
                    },
                  ),
                  Text("公开",style:TextStyle(fontSize: FontSize.NORMAL)),
                  Radio<String>(
                    value: "private",
                    groupValue: openValue,
                    onChanged: (value){
                      this.setState(() {
                        openValue = value;
                      });
                    },
                  ),
                  Text("私有",style:TextStyle(fontSize: FontSize.NORMAL)),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top:20.0),
                padding: EdgeInsets.all(10.0),
                height:65.0,
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    hoverColor: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text("确    定",style:TextStyle(color:Colors.white,fontSize: FontSize.LARGE)),
                    onPressed: (){
                      if (formKey1.currentState.validate()) { // 校验通过则可提交
                        // 通过unameController.text,upasswordController.text获取表单数据
                        Toast.show("提交成功", context);
                      }
                    },
                  ),
                )
            ),
          ],
        )
      ),
    );
  }
}