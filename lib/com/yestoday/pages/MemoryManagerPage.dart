import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/model/MemoryVO.dart';
import 'package:zaijian/com/yestoday/service/MemoryManagerPageService.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

import 'enum/ListViewActionEnum.dart';


class MemoryManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MemoryManagerPageState();
  }
}

class MemoryManagerPageState extends State<MemoryManagerPage> {
  MemoryManagerPageService service = new MemoryManagerPageService();

  // 下拉刷新上拉加载控制器
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<MemoryItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: ZJ_AppBar("列表"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Toast.show("添加新的回忆录", context);
        },
      ),
      body: items.length == 0
          ? Center(child: CircularProgressIndicator())
          : SmartRefresher(
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
                this.loadData(ListViewActionEnum.PULL_DOWN);
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
    this.loadData(null);
  }

  void loadData(ListViewActionEnum action) {
    this.items = [];
    service.getMemories("userId").then((memories) => {
          this.setState(() {
            this.updateData(memories, action);
          })
        });
  }

  void loadMore() {
    service.getMemories("userId").then((memories) => {
          this.setState(() {
            this.updateData(memories, ListViewActionEnum.PULL_UP);
          })
        });
  }

  void updateData(List<MemoryVO> memories, ListViewActionEnum action) {
    memories.forEach((memoryVO) {
      this.items.add(MemoryItem(memoryVO));
    });
    switch (action) {
      case ListViewActionEnum.PULL_DOWN:
        this.refreshController.refreshCompleted();
        break;
      case ListViewActionEnum.PULL_UP:
        this.refreshController.loadComplete();
        break;
      default:
        break;
    }
  }
}

// ignore: must_be_immutable
class MemoryItem extends StatelessWidget {
  MemoryVO memoryVO;

  MemoryItem(this.memoryVO);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5.0, 7.0, 5.0, 7.0),
        margin: EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          ListTile(
              onTap: () {
                Toast.show('打开管理页面', context);
              },
              onLongPress: () {
                Toast.show("长按分享", context);
              },
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              title: Text("        "+memoryVO.title, overflow: TextOverflow.clip),
              trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ZJ_Image.network(memoryVO.icon,width:95.0,height: 60.0))),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: ZJ_Image.network(memoryVO.creatorIcon,
                      width: 30.0,
                      height: 30.0),
                    ),
                  Padding(padding: EdgeInsets.all(2.0)),
                  Text(memoryVO.creator, overflow: TextOverflow.ellipsis)
                ],
              ),
              Text(memoryVO.date,
                  style: TextStyle(fontSize: 12.0, color: Colors.black38))
            ],
          ),
        ]));
  }
}
//ListTile(
//isThreeLine:true,
//onTap: (){
//Toast.show('打开管理页面', context);
//},
//onLongPress: (){
//Toast.show("长按分享", context);
//},
//trailing: ClipRRect(
//borderRadius: BorderRadius.circular(5),
//child: Image(
//width: 75.0,
//height:75.0,
//fit: BoxFit.cover,
//image: NetworkImage(memoryVO.icon),
//),
//),
//title: Text(memoryVO.title, overflow: TextOverflow.clip),
//subtitle: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: [
//Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//ClipOval(
//child: Image(
//width: 24.0,
//height: 24.0,
//fit: BoxFit.cover,
//image: NetworkImage(memoryVO.creatorIcon),
//)),
//Padding(padding: EdgeInsets.all(2.0)),
//Text(memoryVO.creator, overflow: TextOverflow.ellipsis)
//]),
//Text(memoryVO.date, style: TextStyle(fontSize: 12.0))
//],
//), //Text("2020-10-01   发起人：很傻很天真")
////trailing: Text("15+"),
//)
