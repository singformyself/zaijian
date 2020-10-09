
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class RegistryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistryState();
  }
}

class RegistryState extends State<RegistryPage> {
  // 发送验证码后的倒计时
  static final int COUNT_TIME=10;
  int countDown = COUNT_TIME;
  bool canSend = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController uphoneController = TextEditingController();
  TextEditingController uvalidateNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("快速注册"),
      body:Form(
        key:formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height:80.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType:TextInputType.phone,
                controller: uphoneController,
                validator: (value) {
                  if(value.isEmpty) {
                    return "请输入手机号";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.phone_android),
                  hintText: '请输入手机号',
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  alignment:AlignmentDirectional.topEnd,
                  children: [
                    TextFormField(
                      keyboardType:TextInputType.number,
                      controller: uvalidateNumberController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.security),
                        hintText: '请输入验证码',
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          return "请输入验证码";
                        }
                        return null;
                      },
                    ),
                    OutlineButton(
                      onPressed: (){
                        sendValidateNumber();
                      },
                      child: Text(getCountDownText(),style: TextStyle(color:Theme.of(context).primaryColor)),
                    )
                  ],
                )
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children: [
                  Text("注册即同意"),
                  FlatButton(
                    onPressed: (){
                      Toast.show("查看协议", context);
                    },
                    child: Text("《再见用户使用协议》",style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ],
              )
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                height:65.0,
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    hoverColor: Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text("注    册",style:TextStyle(color:Colors.white,fontSize: 16.0)),
                    onPressed: (){
                      if (formKey.currentState.validate()) { // 校验通过则可提交
                        // 通过unameController.text,upasswordController.text获取表单数据
                        Toast.show("提交成功", context);
                      }
                    },
                  ),
                )
            ),
          ],
        ),
      )
    );
  }

  void sendValidateNumber() async {
    if(canSend){
      this.countDown = COUNT_TIME;
      this.canSend = false;
      // TODO 请求后台发送短信
      while(countDown>=0){
        await Future.delayed(Duration(milliseconds: 1000));
        this.setState(() {
          countDown--;
          if (countDown<=0) {
            this.canSend = true;
          }
        });
      }
    }
  }

  String getCountDownText(){
    if (countDown==COUNT_TIME||countDown<=0) {
      return "获取验证码";
    }
    return countDown.toString()+" 秒后无效";
  }
}