import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EyewitnessPage extends StatefulWidget {
  String mid;
  bool creator;
  bool canDelete;

  EyewitnessPage(this.mid, this.canDelete);

  @override
  State<StatefulWidget> createState() {
    return EyewitnessState(mid, canDelete);
  }
}

class EyewitnessState extends State<EyewitnessPage> {
  String mid;
  bool canDelete;

  EyewitnessState(this.mid, this.canDelete);

  int curPage = 0, length = 8;

  // 下拉刷新上拉加载控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<Slidable> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ZJ_AppBar("见证人"),
//      floatingActionButton: FloatingActionButton(
//        // 点击添加见证人
//        child: Icon(Icons.add),
//        onPressed: () {},
//      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        header: WaterDropHeader(waterDropColor: Theme.of(context).primaryColor),
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.loadData();
  }

  // 加载数据，每次都从第一页开始
  void loadData() async {
    curPage = 0;
    this.items = [];
    MemoryApi.eyewitnessList(mid, curPage, length).then((rsp) {
      this.refreshController.refreshCompleted();
      if (rsp[KEY.SUCCESS] && rsp['eyewitness'].length > 0) {
        this.refreshController.resetNoData();
        this.setState(() {
          this.updateData(rsp['eyewitness']);
        });
      } else {
        this.refreshController.loadNoData();
      }
    });
  }

  void loadMore() {
    curPage++;
    MemoryApi.eyewitnessList(mid, curPage, length).then((rsp) {
      this.refreshController.loadComplete();
      if (rsp[KEY.SUCCESS] && rsp['eyewitness'].length > 0) {
        this.setState(() {
          this.updateData(rsp['eyewitness']);
        });
      } else {
        this.refreshController.loadNoData();
      }
    });
  }

  void updateData(dynamic eyewitness) {
    eyewitness.forEach((user) {
      var key = Key(user['id']);
      var item = Slidable(
        key: key,
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: EyewitnessItem(user),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '解除',
            color: Colors.black45,
            icon: Icons.delete,
            onTap: () {
              if (!canDelete) {
                EasyLoading.showInfo('只有回忆创建者才能解除见证人');
                return;
              }
              MemoryApi.deleteEyewitness(mid, user['id']).then((rsp) {
                if (rsp[KEY.SUCCESS]) {
                  EasyLoading.showSuccess('解除成功');
                  this.setState(() {
                    this.items.removeWhere((item) => item.key == key);
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

class EyewitnessItem extends StatelessWidget {
  dynamic user;

  EyewitnessItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 7.0, 5.0, 7.0),
        height: 65,
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
        child: Row(
          children: [
            ClipOval(
                child: ZJ_Image.network(MyApi.OBS_HOST + user['icon'],
                    width: 30.0, height: 30.0)),
            Padding(padding: EdgeInsets.all(3.0)),
            Expanded(
                child: Text(user['nickName'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: FontSize.NORMAL)))
          ],
        ));
  }
}
