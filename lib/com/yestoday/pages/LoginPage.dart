import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/pages/RegistryPage.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginPage>{
  // 发送验证码后的倒计时
  static final int COUNT_TIME=10;
  int countDown = COUNT_TIME;
  bool canSend = true;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  TextEditingController unameController = TextEditingController();
  TextEditingController upasswordController = TextEditingController();
  TextEditingController uphoneController = TextEditingController();
  TextEditingController uvalidateNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title:Text("登录"),bottom: TabBar(
          tabs: [
            Tab(text: "手机快捷登录"),
            Tab(text: "账号密码登录"),
          ],
        ),),
        body:TabBarView(
          children: [
            Form(
              key:formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height:50.0,
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
                    margin: EdgeInsets.only(top:20.0),
                    padding: EdgeInsets.all(10.0),
                    height:65.0,
                    child: SizedBox.expand(
                      child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          hoverColor: Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text("登    录",style:TextStyle(color:Colors.white,fontSize: FontSize.LARGE)),
                          onPressed: (){
                            if (formKey1.currentState.validate()) { // 校验通过则可提交
                              // 通过unameController.text,upasswordController.text获取表单数据
                              Toast.show("提交成功", context);
                            }
                          },
                      ),
                    )
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      height:65.0,
                      child: SizedBox.expand(
                        child: OutlineButton(
                            onPressed: gotoRegistryPage(context),
                            child: Text("还没账号？注册一个吧0.0",style:TextStyle(fontSize: FontSize.LARGE,color:Theme.of(context).primaryColor))),
                      )
                  )
                ],
              ),
            ),
            Form(
              key:formKey2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height:50.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: unameController,
                      validator: (value) {
                        if(value.isEmpty) {
                          return "请输入用户名";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: '请输入用户名',
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType:TextInputType.visiblePassword,
                        controller: upasswordController,
                        obscureText:true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: '请输入密码',
                        ),
                        validator: (value) {
                          if(value.isEmpty) {
                            return "请输入密码";
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          child: Text("忘记密码？",style: TextStyle(color:Theme.of(context).primaryColor)),
                        )
                      ],
                    ),
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
                          child: Text("登    录",style:TextStyle(color:Colors.white,fontSize: 16.0)),
                          onPressed: (){
                            if (formKey2.currentState.validate()) { // 校验通过则可提交
                              // 通过unameController.text,upasswordController.text获取表单数据
                              Toast.show("提交成功", context);
                            }
                          },
                        ),
                      )
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      height:65.0,
                      child: SizedBox.expand(
                        child: OutlineButton(
                            onPressed: gotoRegistryPage(context),
                            color: Theme.of(context).primaryColor,
                            hoverColor: Theme.of(context).primaryColor,
                            child: Text("还没账号？注册一个吧0.0",style:TextStyle(fontSize: 16.0,color:Theme.of(context).primaryColor))),
                      )
                  )
                ],
              ),
            ),
          ],
        )
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

  Function gotoRegistryPage(BuildContext context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegistryPage()));
    };
  }
}