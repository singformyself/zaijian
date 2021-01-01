import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class AccountAndSecurityPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("账号与安全"),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            title: Text("更换手机号"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            title: Text("更换密码"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
        ],
      ),
    );
  }

}