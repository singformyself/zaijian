import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';

class RegistryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistryState();
  }
}

class RegistryState extends State<RegistryPage> {
  // 发送验证码后的倒计时
  static final int COUNT_TIME = 60;
  int countDown = COUNT_TIME;
  bool canSend = true;
  bool stopCount = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar("快速注册"),
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
                    if (!BaseConfig.phoneExp.hasMatch(value)) {
                      return "手机号填写错误";
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
                      OutlinedButton(
                        onPressed: () {
                          sendValidateNumber(phoneController.text, context);
                        },
                        child: Text(getCountDownText(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      )
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("注册即同意"),
                      FlatButton(
                        onPressed: () {
                          EasyLoading.showToast("查看协议");
                        },
                        child: Text("《再见用户使用协议》",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(5.0),
                  height: 65.0,
                  child: SizedBox.expand(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      hoverColor: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("注    册",
                          style: TextStyle(
                              color: Colors.white, fontSize: FontSize.LARGE)),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          doSignup(phoneController.text, codeController.text,
                              context);
                        }
                      },
                    ),
                  )),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    stopCount = true;
  }

  void sendValidateNumber(String phone, BuildContext context) async {
    if (!BaseConfig.phoneExp.hasMatch(phone)) {
      EasyLoading.showInfo('手机号填写错误');
      return;
    }
    if (canSend) {
      // 调用接口发送短信
      LoginApi.sendSms(phone).then((rsp) async {
        if (rsp[KEY.SUCCESS]) {
          // 发送成功，执行倒计时
          EasyLoading.showSuccess(rsp[KEY.MSG]);
          this.countDown = COUNT_TIME;
          this.canSend = false;
          while (countDown >= 0 && !stopCount) {
            await Future.delayed(Duration(seconds: 1));
            if (!stopCount) {
              this.setState(() {
                countDown--;
                if (countDown <= 0) {
                  this.canSend = true;
                }
              });
            }
          }
        } else {
          EasyLoading.showError(rsp[KEY.MSG]);
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

  void doSignup(String phone, String code, BuildContext context) {
    LoginApi.signup(phone, code).then((rsp) async {
      if (rsp[KEY.SUCCESS]) {
        EasyLoading.showSuccess('注册成功');
        await Future.delayed(Duration(milliseconds: 2000));
        while (Navigator.canPop(context)) {
          Navigator.pop(context, rsp[KEY.USER]);
        }
      } else {
        EasyLoading.showError(rsp[KEY.MSG]);
      }
    });
  }
}
