import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com.yestoday.widget/ZJ_AppBar.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MePageState();
  }
}

class MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          AspectRatio(
            aspectRatio: 16 / 8.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 30.0, 3.0, 10.0),
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  Column(
                    // 头像
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Toast.show("进入头像编辑页面", context);
                        },
                        child: ClipOval(
                          child: Image(
                            width: 105.0,
                            height: 105.0,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://zaijian.obs.cn-north-4.myhuaweicloud.com/kjlhfghfdsdfdgf.jpg"),
                          ),
                        ),
                      ),
                      Text("点击编辑",
                          style: TextStyle(color: Colors.white, fontSize: 12.0))
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
                                Text("很傻很天真反对法士大夫",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Row(
                                  children: [
                                    Icon(Icons.verified_user,
                                        color: Colors.amber),
                                    Text("已实名",
                                        style: TextStyle(color: Colors.amber)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.local_offer,
                                        color: Colors.amber),
                                    Text("VIP",
                                        style: TextStyle(color: Colors.amber)),
                                  ],
                                ),
                                Text("点击编辑基本信息",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0))
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
            onTap: (){Toast.show("VIP", context);},
            leading: Icon(Icons.local_offer),
            title: Text("VIP管理"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            onTap: (){Toast.show("打开密码更换页面", context);},
            leading: Icon(Icons.security),
            title: Text("账号与安全"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            onTap: (){Toast.show("关于再见", context);},
            leading: Icon(Icons.info),
            title: Text("关于再见"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            onTap: (){Toast.show("检查版本更新", context);},
            leading: Icon(Icons.refresh),
            title: Text("检查版本更新"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            onTap: (){Toast.show("帮助", context);},
            leading: Icon(Icons.help),
            title: Text("帮助"),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            onTap: (){Toast.show("退出登陆了", context);},
            title: Center(child: Text("退出登陆")),
          ),
          Divider()
        ]));
  }
}
