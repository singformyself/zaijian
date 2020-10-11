import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

class MemoriesPage extends StatefulWidget {
  String id;
  String title;
  String userIcon;
  String userNickName;

  MemoriesPage(this.id, this.title, this.userIcon, this.userNickName);

  @override
  State<StatefulWidget> createState() {
    return MemoriesState(this.id, this.title, this.userIcon, this.userNickName);
  }
}

class MemoriesState extends State<MemoriesPage> {
  String id;
  String title;
  String userIcon;
  String userNickName;

  MemoriesState(this.id, this.title, this.userIcon, this.userNickName);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(userIcon), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            appBar: AppBar(
              backgroundColor: Colors.transparent, elevation:0.0
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 3.0),
                  padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 30.0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: ZJ_Image.network(userIcon,
                                          width: 30.0, height: 30.0),
                                    ),
                                    Padding(padding: EdgeInsets.all(3.0)),
                                    Text(userNickName,
                                        overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white)),
                                  ],
                                )
                              ])),
                      Text("        " + title,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.clip),
                      Divider(color: Colors.white.withOpacity(0.5)),
                      Text('2016-01-01' + " ~ " + 'myFocus.endDate',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.0)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      color: Colors.white,
                      child: ListView.builder(itemBuilder: _itemBuilder,itemCount: 50,)
                  ),
                ),
              ],
            )
        )
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: NestedScrollView(
//          headerSliverBuilder: sliverBuilder,
//          body: Container(
//            child: ListView.builder(
//              itemBuilder: _itemBuilder,
//              itemCount: 15,
//            ),
//          )),
//    );
//  }
  List<Widget> sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
          centerTitle: false,
          //标题居中
          expandedHeight: 300.0,
          //展开高度200
          collapsedHeight: 80.0,
          floating: false,
          //不随着滑动隐藏标题
          pinned: true,
          //固定在顶部
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(title,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 18.0)),
              background: ZJ_Image.network(
                userIcon,
                color: Colors.black.withOpacity(0.2),
                colorBlendMode: BlendMode.srcATop,
              )))
    ];
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('无与伦比的标题+$index'),
    );
  }
}
