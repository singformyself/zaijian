import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/model/UserVO.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';


import 'LoginPage.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MePageState();
  }
}

class MePageState extends State<MePage> {
  UserVO userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ZJ_AppBar("我的"),
        body: ListView(children: [
          AspectRatio(
            aspectRatio: 16 / 8.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 3.0, 20.0),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                children: [
                  Column(
                    // 头像
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (userInfo != null) {
                            Toast.show("进入头像编辑页面", context);
                          } else {
                            Toast.show("进入登陆页面", context);
                          }
                        },
                        child: ClipOval(
                          child: userInfo != null
                              ? ZJ_Image.network(userInfo.icon,
                                  width: 105.0, height: 105.0)
                              : Icon(Icons.person,size: 105, color:Colors.black12),
                        ),
                      ),
                      Text("点击编辑",
                          style: TextStyle(color: Colors.white, fontSize: FontSize.SMALL))
                    ],
                  ), // 头像
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Toast.show("打开基本信息编辑页面", context);
                          },
                          child: Container(
                            height: 120.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    userInfo != null
                                        ? userInfo.nickName
                                        : "未登陆",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: FontSize.LARGE,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                getRealNameInfo(),
                                getVipInfo(),
                                Text("点击编辑基本信息",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: FontSize.SMALL))
                              ],
                            ),
                          ))
                    ],
                  ) // 用户信息
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Toast.show("VIP", context);
            },
            leading: Icon(Icons.local_offer),
            title: Text("VIP管理",style:TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Toast.show("打开密码更换页面", context);
            },
            leading: Icon(Icons.security),
            title: Text("账号与安全",style:TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Toast.show("关于再见", context);
            },
            leading: Icon(Icons.info),
            title: Text("关于再见",style:TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Toast.show("检查版本更新", context);
            },
            leading: Icon(Icons.refresh),
            title: Text("检查版本更新",style:TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Toast.show("帮助", context);
            },
            leading: Icon(Icons.help),
            title: Text("帮助",style:TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              if(userInfo!=null){
                Toast.show("退出登陆了", context);
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
              }
            },
            title: Center(child: Text(userInfo!=null?"退出登陆":"点击登陆")),
          ),
          Divider()
        ]));
  }

  @override
  void initState() {
    getLoginUser();
  }

  void getLoginUser() {
    SharedPreferences.getInstance().then((pfs) => {
          this.setState(() {
            this.userInfo = pfs.get(UserVO.LOGIN_KEY);
          })
        });
  }

  Widget getRealNameInfo() {
    String text = "未实名";
    Color color = Colors.white;
    if (userInfo != null && userInfo.name != null) {
      text = "已实名";
      color = Colors.amber;
    }
    return Row(
      children: [
        Icon(Icons.verified_user, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  Widget getVipInfo() {
    String text = "普通";
    Color color = Colors.white;
    if (userInfo != null && userInfo.vip != null) {
      text = userInfo.vip;
      color = Colors.amber;
    }
    return Row(
      children: [
        Icon(Icons.local_offer, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
