import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zaijian/com/yestoday/pages/MemoryListPage.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'AddMemoryPage.dart';

/**
 * 我的见证列表
 */
class EyewitnessMemoryListPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
        return EyewitnessMemoryListPageState();
    }
}

class EyewitnessMemoryListPageState extends State<EyewitnessMemoryListPage> {
    int curPage = 0, length = 8;
    dynamic user;

    // 下拉刷新上拉加载控制器
    RefreshController refreshController =
    RefreshController(initialRefresh: false);
    List<Slidable> items = [];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: ZJ_AppBar("见证列表"),
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

    @override
    void dispose() {
        super.dispose();
        items=null;
        refreshController.dispose();
    }
    // 加载数据，每次都从第一页开始
    void loadData() async {
        curPage = 0;
        this.items = [];
        user = await MyUtil.getUser();
        MemoryApi.eyewitnessMemoryPageList(user[KEY.USER_ID], curPage, length).then((rsp) {
            this.refreshController.refreshCompleted();
            if (rsp[KEY.SUCCESS] && rsp['memories'].length > 0) {
                this.setState(() {
                    this.updateData(rsp['memories']);
                });
            } else {
                this.refreshController.loadNoData();
            }
        });
    }

    void loadMore() {
        curPage++;
        MemoryApi.eyewitnessMemoryPageList(user[KEY.USER_ID], curPage, length).then((rsp) {
            this.refreshController.loadComplete();
            if (rsp[KEY.SUCCESS] && rsp['memories'].length > 0) {
                this.refreshController.resetNoData();
                this.setState(() {
                    this.updateData(rsp['memories']);
                });
            } else {
                this.refreshController.loadNoData();
            }
        });
    }

    void updateData(dynamic memories) {
        memories.forEach((memoryVO) {
            var key = Key(memoryVO['id']);
            var item = Slidable(
                key: key,
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: MemoryItem(user, memoryVO),
                secondaryActions: <Widget>[
                    IconSlideAction(
                        caption: '放弃见证',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                            MemoryApi.deleteEyewitness(memoryVO['id'], user['id']).then((rsp) {
                                if (rsp[KEY.SUCCESS]) {
                                    EasyLoading.showSuccess('操作成功');
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

