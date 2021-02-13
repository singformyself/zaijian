import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/api/LoginApi.dart';
import 'package:zaijian/com/yestoday/api/UserApi.dart';
import 'package:zaijian/com/yestoday/utils/Msg.dart';

class ChangePhonePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePhoneState();
  }
}

class ChangePhoneState extends State<ChangePhonePage> {
  dynamic user;
  String nowPhone = '';

  // 发送验证码后的倒计时
  static final int COUNT_TIME = 60;
  int countDown = COUNT_TIME;
  bool canSend = true;
  bool stopCount = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar("更换绑定手机"),
        floatingActionButton: FloatingActionButton(
          child: Text("确定"),
          onPressed: () {
            submit(phoneController.text, codeController.text, context);
          },
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(5,0,5,5),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ListTile(
                  leading:
                      Text("当前手机号", style: TextStyle(fontSize: FontSize.LARGE)),
                  title: Text(nowPhone,
                      style: TextStyle(fontSize: FontSize.LARGE))),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone_android),
                  hintText: '请输入新手机号',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入手机号";
                  }
                  if (!BaseConfig.phoneExp.hasMatch(value)) {
                    return "手机号填写错误";
                  }
                  return null;
                },
              ),
              Stack(
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
                      sendValidateNumber(phoneController.text, context);
                    },
                    child: Text(getCountDownText(),
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              )
            ])));
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((stg) {
      this.setState(() {
        user = json.decode(stg.get(MyKeys.USER));
        nowPhone = user['phone'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopCount = true;
  }

  void sendValidateNumber(String phone, BuildContext context) async {
    if (!BaseConfig.phoneExp.hasMatch(phone)) {
      Msg.alert('手机号填写错误', context);
      return;
    }
    if (canSend) {
      // 调用接口发送短信
      LoginApi.sendSms(phone).then((rsp) async {
        if (rsp[MyKeys.SUCCESS]) {
          // 发送成功，执行倒计时
          Msg.tip(rsp[MyKeys.MSG], context);
          this.countDown = COUNT_TIME;
          this.canSend = false;
          while (countDown >= 0 && !stopCount) {
            await Future.delayed(Duration(milliseconds: 1000));
            this.setState(() {
              countDown--;
              if (countDown <= 0) {
                this.canSend = true;
              }
            });
          }
        } else {
          Msg.alert(rsp['msg'], context);
        }
      });
    }
  }

  String getCountDownText() {
    if (countDown == COUNT_TIME || countDown <= 0) {
      return "获取验证码";
    }
    return countDown.toString() + " 秒后无效";
  }

  void submit(String phone, String code, BuildContext context) {
    UserApi.changePhone(user['id'], phone, code).then((rsp) {
      if (rsp[MyKeys.SUCCESS]) {
        Msg.tip("修改成功", context);
        // 更新本地数据
        SharedPreferences.getInstance().then((storage) {
          storage.setString(MyKeys.TOKEN, rsp[MyKeys.TOKEN]);
          dynamic user = rsp[MyKeys.USER];
          storage.setString(MyKeys.USER, json.encode(user));
          this.setState(() {
            nowPhone = user['phone'];
          });
        });
      } else {
        Msg.alert(rsp[MyKeys.MSG], context);
      }
    });
  }
}
