import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/pages/RegistryPage.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage> {
  // 发送验证码后的倒计时
  static final int COUNT_TIME = 60;
  int countDown = COUNT_TIME;
  bool canSend = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar("验证码登录"),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (value) {
                    if (value.isEmpty) {
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
                  padding: EdgeInsets.all(5.0),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: codeController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.security),
                          hintText: '请输入验证码',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "请输入验证码";
                          }
                          return null;
                        },
                      ),
                      OutlineButton(
                        onPressed: () {
                          sendValidateNumber();
                        },
                        child: Text(getCountDownText(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.all(5.0),
                  height: 65.0,
                  child: SizedBox.expand(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      hoverColor: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("登    录",
                          style: TextStyle(
                              color: Colors.white, fontSize: FontSize.LARGE)),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          // 校验通过则可提交
                          // 通过unameController.text,upasswordController.text获取表单数据
                          Toast.show("提交成功", context);
                        }
                      },
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(5.0),
                  height: 65.0,
                  child: SizedBox.expand(
                    child: OutlineButton(
                        onPressed: gotoRegistryPage(context),
                        child: Text("还没账号？赶快注册一个吧0.0",
                            style: TextStyle(
                                fontSize: FontSize.LARGE,
                                color: Theme.of(context).primaryColor))),
                  ))
            ],
          ),
        ));
  }

  void sendValidateNumber() async {
    if (canSend) {
      this.countDown = COUNT_TIME;
      this.canSend = false;
      // TODO 请求后台发送短信
      while (countDown >= 0) {
        await Future.delayed(Duration(milliseconds: 1000));
        this.setState(() {
          countDown--;
          if (countDown <= 0) {
            this.canSend = true;
          }
        });
      }
    }
  }

  String getCountDownText() {
    if (countDown == COUNT_TIME || countDown <= 0) {
      return "获取验证码";
    }
    return countDown.toString() + " 秒后无效";
  }

  Function gotoRegistryPage(BuildContext context) {
    return () {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => RegistryPage()));
    };
  }
}
