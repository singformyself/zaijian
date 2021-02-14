import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/api/MemoryApi.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';
import 'package:zaijian/com/yestoday/pages/MemoryManagementPage.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/service/MemoryManagerPageService.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:date_format/date_format.dart';
import 'AddMemoryPage.dart';
import 'enum/ListViewActionEnum.dart';

class MemoryListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MemoryListPageState();
  }
}

class MemoryListPageState extends State<MemoryListPage> {
  int curPage = 0, length = 8;
  String uid;
  MemoryManagerPageService service = new MemoryManagerPageService();

  // 下拉刷新上拉加载控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<MemoryItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: ZJ_AppBar("回忆列表"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddMemoryPage()));
          // 如果新增了记录，则刷新列表
          if (result==true) {
            loadData();
          }
        },
      ),
      body: items.length == 0
          ? Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: refreshController,
              enablePullUp: true,
              header: WaterDropHeader(
                  waterDropColor: Theme.of(context).primaryColor),
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
    curPage=0;
    this.items = [];
    SharedPreferences stg = await SharedPreferences.getInstance();
    uid = stg.get(MyKeys.USER_ID);
    MemoryApi.pageList(uid, curPage, length).then((rsp) {
      this.refreshController.refreshCompleted();
      if (rsp[MyKeys.SUCCESS] && rsp['memories'].length > 0) {
        this.setState(() {
          this.updateData(rsp['memories']);
        });
      }
    });
  }

  void loadMore() {
    curPage++;
    MemoryApi.pageList(uid, curPage, length).then((rsp) {
      this.refreshController.loadComplete();
      if (rsp[MyKeys.SUCCESS] && rsp['memories'].length > 0) {
        this.setState(() {
          this.updateData(rsp['memories']);
        });
      }
    });
  }

  void updateData(dynamic memories) {
    memories.forEach((memoryVO) {
      this.items.add(MemoryItem(memoryVO));
    });
  }
}

// ignore: must_be_immutable
class MemoryItem extends StatelessWidget {
  dynamic memory;

  MemoryItem(this.memory);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5.0, 7.0, 5.0, 7.0),
        margin: EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MemoryManagementPage(memory)));
              },
              onLongPress: () {
                Toast.show("长按分享", context);
              },
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              title: Text("        " + memory['title'],
                  style: TextStyle(fontSize: FontSize.NORMAL),
                  overflow: TextOverflow.clip),
              trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ZJ_Image.network(BaseConfig.OBS_HOST+memory['icon'],
                      width: 95.0, height: 60.0))),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDate(DateTime.fromMillisecondsSinceEpoch(memory['createTime']), [yyyy, '-', mm, '-', dd,' ',HH,':',mm]),
                  style: TextStyle(
                      fontSize: FontSize.SMALL, color: Colors.black54))
            ],
          ),
        ]));
  }
}
