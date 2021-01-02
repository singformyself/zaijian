import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class ChangePasswordPage extends StatelessWidget {
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("更换密码"),
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
                keyboardType: TextInputType.visiblePassword,
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: '请输入旧密码',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入旧密码";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: '请输入新密码',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入新密码";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: '再次输入新密码',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "再次输入新密码";
                  }
                  return null;
                },
              )
            ])
      )
    );
  }
}
