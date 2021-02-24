import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zaijian/com/yestoday/pages/EyewitnessPage.dart';
import 'package:zaijian/com/yestoday/pages/UploadPhotoPage.dart';
import 'package:zaijian/com/yestoday/pages/UploadVideoPage.dart';
import 'package:zaijian/com/yestoday/service/MyTask.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  MemoryManagementState(this.user, this.memory);

  MemoryItems memoryItems;

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
                Container(
                    padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                    color: Theme.of(context).primaryColor,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('我的见证', style: TextStyle(color: Colors.white)),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    bool res = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UploadPhotoPage(memory)));
                                    if (res != null && res) {
                                      this.memoryItems.refresh();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.file_upload,
                                          color: Colors.white, size: 18),
                                      Text("照片",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  )),
                              Text("|",
                                  style: TextStyle(color: Colors.white54)),
                              TextButton(
                                  onPressed: () async {
                                    bool res = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UploadVideoPage(
                                                    memory: memory)));
                                    if (res != null && res) {
                                      this.memoryItems.refresh();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.file_upload,
                                          color: Colors.white, size: 18),
                                      Text("视频",
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ))
                            ],
                          )
                        ])),
                Expanded(
                  child: memoryItems,
                )
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    memoryItems = MemoryItems(memory['id'], user['id']);
    this.canDelete = user['id'] == memory['creator'];
  }
}

class MemoryItems extends StatefulWidget {
  String mid;
  String uid;
  MemoryItemsState state;

  MemoryItems(this.mid, this.uid);

  @override
  State<StatefulWidget> createState() {
    return state = MemoryItemsState(mid, uid);
  }

  void refresh() {
    state.refresh();
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
  }

  @override
  void dispose() {
    super.dispose();
    items = null;
    refreshController.dispose();
  }

  // 加载数据，每次都从第一页开始
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
              MemoryApi.deleteById(MemoryApi.DELETE_ITEM, memoryItem['id'])
                  .then((rsp) {
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

  void refresh() {
    this.loadData();
  }
}

class MemoryItem extends StatelessWidget {
  dynamic memoryItem;

  MemoryItem(this.memoryItem);

  @override
  Widget build(BuildContext context) {
    String createTime = formatDate(
        DateTime.fromMillisecondsSinceEpoch(memoryItem['createTime']),
        [yy, '/', mm, '/', dd, '\n', hh, ':', mm, ':', ss]);
    return Container(
        padding: EdgeInsets.fromLTRB(5.0, 5, 5.0, 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
        child: Column(children: [
          ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: memoryItem['status'] == 9
                  ? Text(createTime)
                  : MyProgress(memoryItem['id'], createTime),
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
                  Container(
                      padding: EdgeInsets.all(1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              memoryItem['type'] == 0
                                  ? ''
                                  : memoryItem['urls'].length.toString(),
                              style: TextStyle(color: Colors.white)),
                          Icon(
                              memoryItem['type'] == 0
                                  ? Icons.videocam
                                  : Icons.photo,
                              color: Colors.white.withOpacity(0.9),size: 16,)
                        ],
                      ))
                ],
              )),
        ]));
  }
}

class MyProgress extends StatefulWidget {
  String itemId;
  String createTime;

  MyProgress(this.itemId, this.createTime);

  @override
  State<StatefulWidget> createState() {
    return MyProgressState(itemId, createTime);
  }
}

class MyProgressState extends State<MyProgress> {
  String itemId;
  String createTime;
  bool living = true;
  double percent = 0;
  int status = 0;

  MyProgressState(this.itemId, this.createTime);

  @override
  Widget build(BuildContext context) {
    return status == 9
        ? Text(createTime)
        : CircularPercentIndicator(
            radius: 38.0,
            lineWidth: 2.5,
            percent: percent,
            center: new Text((percent * 100).ceilToDouble().toString() + "%",
                style: TextStyle(fontSize: 11)),
            progressColor: Colors.green,
            footer: getText(),
            onAnimationEnd: () {
              status = 9;
              refresh();
            },
          );
  }

  @override
  void initState() {
    super.initState();
    startListen();
  }

  @override
  void dispose() {
    super.dispose();
    living = false;
  }

  Future<void> startListen() async {
    while (living && percent < 1) {
      var res = MyTask.instance.getProgressValue(itemId);
      if (res == null) {
        await Future.delayed(Duration(milliseconds: 1000));
        continue;
      }
      percent = res;
      status = 1;
      refresh();
      await Future.delayed(Duration(milliseconds: 100));
    }
    status = 9;
    refresh();
  }

  void refresh() {
    if (living) {
      this.setState(() {});
    }
  }

  Text getText() {
    switch (status) {
      case 0:
        return Text('等待上传', style: TextStyle(fontSize: 9));
      case 1:
        return Text('正在上传', style: TextStyle(fontSize: 9));
      default:
        return Text('上传完成', style: TextStyle(fontSize: 9));
    }
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
    return Column(
      children: [
        publiciy
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EyewitnessPage(id, canDelete)));
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                    color: Colors.black.withOpacity(0.5),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: getEyewitness(),
                        ),
                        Icon(Icons.more_horiz, color: Colors.white)
                      ],
                    )))
            : Container(),
      ],
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
