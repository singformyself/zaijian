import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
class ChangePhonePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChangePhoneState();
  }

}
class ChangePhoneState extends State<ChangePhonePage>{
  // 发送验证码后的倒计时
  static final int COUNT_TIME=10;
  int countDown = COUNT_TIME;
  bool canSend = true;
  TextEditingController phoneController = TextEditingController();
  TextEditingController uvalidateNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar("更换绑定手机"),
        floatingActionButton: FloatingActionButton(
          child: Text("确定"),
          onPressed: () {
            // TODO submit
          },
        ),
        body: Container(
            padding:EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone_android),
                      hintText: '请输入手机号',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "请输入手机号";
                      }
                      return null;
                    },
                  ),
                  Stack(
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
                ])
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