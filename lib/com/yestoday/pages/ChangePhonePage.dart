import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';

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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        body: Form(
            key: formKey,
            child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                          leading: Text("当前手机号",
                              style: TextStyle(fontSize: FontSize.LARGE)),
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
                          OutlinedButton(
                            onPressed: () {
                              sendValidateNumber(phoneController.text, context);
                            },
                            child: Text(getCountDownText(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        ],
                      )
                    ]))));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    user = await MyUtil.getUser();
    nowPhone = user['phone'];
    this.setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    stopCount = true;
  }

  void sendValidateNumber(String phone, BuildContext context) async {
    if(phone==null||phone.length==0){
      EasyLoading.showInfo('请输入手机号');
      return;
    }
    if (!BaseConfig.phoneExp.hasMatch(phone)) {
      EasyLoading.showInfo('手机号填写错误');
      return;
    }
    if (canSend) {
      // 调用接口发送短信
      LoginApi.sendSms(phone).then((rsp) async {
        if (rsp[KEY.SUCCESS]) {
          // 发送成功，执行倒计时
          EasyLoading.showToast(rsp[KEY.MSG]);
          this.countDown = COUNT_TIME;
          this.canSend = false;
          while (countDown >= 0 && !stopCount) {
            await Future.delayed(Duration(milliseconds: 1000));
            if (!stopCount) {
              // 页面关闭了就不再setState了
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

  void submit(String phone, String code, BuildContext context) {
    if (!formKey.currentState.validate()) {
      return;
    }
    UserApi.changePhone(user['id'], phone, code).then((rsp) {
      if (rsp[KEY.SUCCESS]) {
        EasyLoading.showSuccess("修改成功");
        this.setState(() {
          nowPhone = user['phone'];
        });
      } else {
        EasyLoading.showError(rsp[KEY.MSG]);
      }
    });
  }
}
