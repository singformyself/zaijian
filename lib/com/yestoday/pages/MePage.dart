import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/pages/AboutZaiJianPage.dart';
import 'package:zaijian/com/yestoday/pages/AccountAndSecurityPage.dart';
import 'package:zaijian/com/yestoday/pages/EditBaseInfoPage.dart';
import 'package:zaijian/com/yestoday/pages/EditHeadIconPage.dart';
import 'package:zaijian/com/yestoday/pages/RegistryPage.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'LoginPage.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MePageState();
  }
}

class MePageState extends State<MePage> {
  dynamic user; // 用户数据从存储系统里获取

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
                        onTap: () async {
                          if (user == null) {
                            EasyLoading.showToast('请先登陆');
                            return;
                          }
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditHeadIconPage(user)));
                          if (result != null) {
                            this.setState(() {
                              user = result;
                            });
                          }
                        },
                        child: ClipOval(
                          child: user != null && user['icon'] != null
                              ? ZJ_Image.network(MyApi.OBS_HOST+user['icon'],
                                  width: 105.0, height: 105.0)
                              : ExtendedImage.asset('assets/default.jpg',
                              width: 105.0, height: 105.0),
                        ),
                      ),
                      Text("点击编辑",
                          style: TextStyle(
                              color: Colors.white, fontSize: FontSize.SMALL))
                    ],
                  ), // 头像
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton(
                          onPressed: () async {
                            if (user == null) {
                              EasyLoading.showToast('请先登陆');
                              return;
                            }
                            dynamic result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditBaseInfoPage()));
                            if (result!=null) {
                              this.setState(() {
                                user = result;
                              });
                            }
                          },
                          child: Container(
                            height: 120.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user != null ? user['nickName'] : "未登陆",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: FontSize.LARGE,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                getVipInfo(),
                                Text("点击编辑基本信息",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.SMALL))
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
              if (user == null) {
                EasyLoading.showToast('请先登陆');
                return;
              }
            },
            leading: Icon(Icons.local_offer),
            title: Text("VIP管理", style: TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              if (user == null) {
                EasyLoading.showToast('请先登陆');
                return;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AccountAndSecurityPage()));
            },
            leading: Icon(Icons.security),
            title: Text("账号与安全", style: TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AboutZaiJianPage()));
            },
            leading: Icon(Icons.info),
            title: Text("关于再见", style: TextStyle(fontSize: FontSize.NORMAL)),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          Padding(padding: EdgeInsets.only(top: 60)),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () async {
              if (user != null) {
                loginOut(context);
              } else {
                dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                if (result != null) {
                  this.setState(() {
                    user = result;
                  });
                }
              }
            },
            title: Center(
                child: Text(user != null ? "退出登陆" : "登陆",
                    style: TextStyle(color: Theme.of(context).primaryColor))),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            onTap: () async {
              if (user != null) {
                return;
              }
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RegistryPage()));
              if (result != null) {
                this.setState(() {
                  user = result;
                });
              }
            },
            title: Center(
                child: Text(user == null ? "注册" : "",
                    style: TextStyle(color: Theme.of(context).primaryColor))),
          )
        ]));
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((stg) {
      String userJson = stg.get(KEY.USER);
      if (userJson != null) {
        this.setState(() {
          user = json.decode(userJson);
        });
      }
    });
  }


  Widget getVipInfo() {
    String text = "普通";
    Color color = Colors.white;
    if (user != null && user['vip'] != null) {
      text = Vip.getVip(user['vip']);
      color = Colors.amber;
    }
    return Row(
      children: [
        Icon(Icons.person_pin, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  void loginOut(BuildContext context) {
    SharedPreferences.getInstance().then((stg) {
      stg.clear();
      this.setState(() {
        user = null;
      });
      EasyLoading.showInfo("已退出登陆");
    });
  }
}
