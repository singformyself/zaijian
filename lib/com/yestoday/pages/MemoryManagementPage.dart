import 'dart:collection';

import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zaijian/com/yestoday/pages/EyewitnessPage.dart';
import 'package:zaijian/com/yestoday/pages/UploadPhotoPage.dart';
import 'package:zaijian/com/yestoday/pages/UploadVideoPage.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:date_format/date_format.dart';

/**
 * 回忆管理页面，展示回忆详情，回忆见证人，图片上传，视频上传
 */
class MemoryManagementPage extends StatefulWidget {
  dynamic user;
  dynamic memory;

  MemoryManagementPage(this.user, this.memory);

  @override
  State<StatefulWidget> createState() {
    return MemoryManagementState(user, memory);
  }
}

class MemoryManagementState extends State<MemoryManagementPage>
    with SingleTickerProviderStateMixin {
  dynamic user;
  dynamic memory;
  bool canDelete = false; // 只有回忆创建者才可以删除回忆记录和见证人
  //List<Eyewitness> eyewitness = [Eyewitness(), Eyewitness(), Eyewitness()];
  Animation<double> _animation;
  AnimationController _animationController;

  MemoryManagementState(this.user, this.memory);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: ExtendedNetworkImageProvider(
                    MyApi.OBS_HOST + memory['icon'],
                    cache: true),
                fit: BoxFit.fitWidth)),
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.2),
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
          body: Column(
            children: [
              Header(user, memory),
              BriefEyewitness(memory['id'], memory['publicity'], canDelete),
              Expanded(
                child: MemoryItems(memory['id'], user['id']),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title: "照片",
                iconColor: Colors.white,
                bubbleColor: Theme.of(context).primaryColor,
                icon: Icons.file_upload,
                titleStyle:
                    TextStyle(fontSize: FontSize.NORMAL, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UploadPhotoPage()));
                },
              ),
              //Floating action menu item
              Bubble(
                title: "视频",
                iconColor: Colors.white,
                bubbleColor: Theme.of(context).primaryColor,
                icon: Icons.file_upload,
                titleStyle:
                    TextStyle(fontSize: FontSize.NORMAL, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UploadVideoPage(memory: memory)));
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: Colors.white,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: Theme.of(context).primaryColor,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
        curve: Curves.bounceInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    this.canDelete = user['id'] == memory['creator'];
  }
}

class MemoryItems extends StatefulWidget {
  String mid;
  String uid;

  MemoryItems(this.mid, this.uid);

  @override
  State<StatefulWidget> createState() {
    return MemoryItemsState(mid, uid);
  }
}

class MemoryItemsState extends State<MemoryItems> {
  String mid;
  String uid;

  MemoryItemsState(this.mid, this.uid);

  int curPage = 0, length = 8;

  // 下拉刷新上拉加载控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<Slidable> items = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          header:
              WaterDropHeader(waterDropColor: Theme.of(context).primaryColor),
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            completeDuration: Duration(milliseconds: 500),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return items[index];
            },
            itemCount: items.length,
          ),
          onRefresh: () async {
            this.loadData();
          },
          onLoading: () async {
            this.loadMore();
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    loadData();
  } // 加载数据，每次都从第一页开始

  void loadData() async {
    curPage = 0;
    this.items = [];
    var params = {
      'mid': mid,
      'creator': uid,
      'curPage': curPage,
      'length': length
    };
    MemoryApi.getList(MemoryApi.GET_ITEM_UPLOAD_HIS_PAGE_LIST, params)
        .then((rsp) {
      this.refreshController.refreshCompleted();
      if (rsp[KEY.SUCCESS] && rsp['items'].length > 0) {
        this.setState(() {
          this.updateData(rsp['items']);
        });
      } else {
        this.refreshController.loadNoData();
      }
    });
  }

  void loadMore() {
    curPage++;
    var params = {
      'mid': mid,
      'creator': uid,
      'curPage': curPage,
      'length': length
    };
    MemoryApi.getList(MemoryApi.GET_ITEM_UPLOAD_HIS_PAGE_LIST, params)
        .then((rsp) {
      this.refreshController.loadComplete();
      if (rsp[KEY.SUCCESS] && rsp['items'].length > 0) {
        this.refreshController.resetNoData();
        this.setState(() {
          this.updateData(rsp['items']);
        });
      } else {
        this.refreshController.loadNoData();
      }
    });
  }

  void updateData(dynamic list) {
    list.forEach((memoryItem) {
      var key = Key(memoryItem['id']);
      var item = Slidable(
        key: key,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: MemoryItem(memoryItem),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              MemoryApi.deleteById(MemoryApi.DELETE_ITEM, memoryItem['id']).then((rsp) {
                if (rsp[KEY.SUCCESS]) {
                  EasyLoading.showSuccess('删除成功');
                  this.setState(() {
                    this.items.removeWhere((element) => element.key == key);
                  });
                } else {
                  EasyLoading.showError(rsp[KEY.MSG]);
                }
              });
            },
          ),
        ],
      );

      this.items.add(item);
    });
  }
}

class MemoryItem extends StatelessWidget {
  dynamic memoryItem;

  MemoryItem(this.memoryItem);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5.0, 5, 5.0, 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
        child: Column(children: [
          ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Text(formatDate(
                  DateTime.fromMillisecondsSinceEpoch(memoryItem['createTime']),
                  [yy, '/', mm, '/', dd, '\n', hh, ':', mm, ':', ss])),
              title: Text(memoryItem['title'],
                  style: TextStyle(fontSize: FontSize.NORMAL),
                  overflow: TextOverflow.clip),
              trailing: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ZJ_Image.network(
                          MyApi.OBS_HOST + memoryItem['icon'],
                          width: 95.0,
                          height: 60.0)),
                  Icon(memoryItem['type'] == 0 ? Icons.videocam : Icons.photo,
                      color: Colors.white.withOpacity(0.9))
                ],
              )),
        ]));
  }
}

class BriefEyewitness extends StatefulWidget {
  String id;
  bool publiciy;
  bool canDelete;

  BriefEyewitness(this.id, this.publiciy, this.canDelete);

  @override
  State<StatefulWidget> createState() {
    return BriefEyewitnessState(id, publiciy, canDelete);
  }
}

class BriefEyewitnessState extends State<BriefEyewitness> {
  String id;
  bool publiciy;
  bool canDelete;
  List<dynamic> eyewitness = []; // 见证人数组
  BriefEyewitnessState(this.id, this.publiciy, this.canDelete);

  @override
  void initState() {
    super.initState();
    // 只拿前面3个见证人
    MemoryApi.eyewitnessList(id, 0, 3).then((rsp) {
      if (rsp[KEY.SUCCESS] && rsp['eyewitness'].length > 0) {
        this.setState(() {
          eyewitness.addAll(rsp['eyewitness']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget hasData = GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  EyewitnessPage(id, canDelete)));
        },
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(bottom: BorderSide(color: Colors.black12))),
            padding: EdgeInsets.all(5),
            height: 90,
            child: Column(
              children: [
                Container(
                  height: 45,
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: getEyewitness(),
                    ),
                    Icon(Icons.more_horiz, color: Colors.white)
                  ],
                )),
                Divider(color: Colors.white),
                Row(children: [
                  Text('我的见证', style: TextStyle(color: Colors.white))
                ])
              ],
            )));
    return publiciy
        ? hasData
        : Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(bottom: BorderSide(color: Colors.black12))),
            height: 10,
          );
  }

  List<Widget> getEyewitness() {
    List<Widget> arr = [];
    arr.add(Text("见证人：", style: TextStyle(color: Colors.white)));
    if (eyewitness.isEmpty) {
      arr.add(Text("还没有见证人，快去添加见证人吧😂",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.yellow)));
      return arr;
    }
    eyewitness.forEach((element) {
      arr.add(UserIcon(element));
    });
    return arr;
  }
}

class Header extends StatelessWidget {
  dynamic user;
  dynamic memory;

  Header(this.user, this.memory);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(0.0, 20.0), //阴影xy轴偏移量
            blurRadius: 30.0, //阴影模糊程度
            spreadRadius: 30.0 //阴影扩散程度
            )
      ]),
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
                            child: ZJ_Image.network(
                                MyApi.OBS_HOST + user['icon'],
                                width: 30.0,
                                height: 30.0)),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Text(user['nickName'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: FontSize.NORMAL)),
                      ],
                    )
                  ])),
          Text("        " + memory['title'],
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.clip),
          Divider(color: Colors.white.withOpacity(0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(memory['createTime']),
                      [yyyy, '-', mm, '-', dd, ' ', HH, ':', mm]),
                  style:
                      TextStyle(color: Colors.white, fontSize: FontSize.SMALL)),
              Text(memory['publicity'] ? '可见状态：公开' : '可见状态：私有',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  dynamic user;

  UserIcon(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
      width: 90,
      child: Row(
        children: [
          ClipOval(
            child: ZJ_Image.network(MyApi.OBS_HOST + user['icon'],
                width: 30.0, height: 30.0),
          ),
          Expanded(
              child: Text(
            user['nickName'],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.white),
          )),
        ],
      ),
    );
  }
}
