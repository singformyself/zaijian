import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/model/MemoryVO.dart';
import 'package:zaijian/com/yestoday/model/MyFocusVO.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/service/MemoriesPageService.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

import 'enum/ListViewActionEnum.dart';

// ignore: must_be_immutable
class MemoriesPage extends StatefulWidget {
  MyFocusVO focusVO;

  MemoriesPage(this.focusVO);

  @override
  State<StatefulWidget> createState() {
    return MemoriesState(focusVO);
  }
}

class MemoriesState extends State<MemoriesPage> {
  MemoriesPageService service = MemoriesPageService();
  MyFocusVO focusVO;
  List<MediumItem> items = [];
  MemoriesState(this.focusVO);
  // 下拉刷新上拉加载控制器
  RefreshController refreshController = RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment:Alignment.topCenter,
                image: ExtendedNetworkImageProvider(focusVO.icon, cache:true),fit: BoxFit.fitWidth)),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation:0.0),
            body: Column(
              children: [
                Header(focusVO),
                Expanded(
                  child: Container(
                      color: Colors.white,
                      child: SmartRefresher(
                        controller: refreshController,
                        enablePullUp: true,
                        header: WaterDropHeader(waterDropColor: Theme.of(context).primaryColor),
                        footer: ClassicFooter(
                          loadStyle: LoadStyle.ShowWhenLoading,
                          completeDuration: Duration(milliseconds: 200),
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
                      )
                  ),
                ),
              ],
            )
        )
    );
  }
  @override
  void initState() {
    super.initState();
    this.loadData(null);
  }

  void loadData(ListViewActionEnum action) {
    this.items = [];
    service.genMediumItems("id").then((mediums) => {
      this.setState(() {
        this.updateData(mediums, action);
      })
    });
  }

  void loadMore() {
    service.genMediumItems("id").then((mediums) => {
      this.setState(() {
        this.updateData(mediums, ListViewActionEnum.PULL_UP);
      })
    });
  }

  void updateData(List<MediumVO> mediums, ListViewActionEnum action) {
    mediums.forEach((medium) {
      this.items.add(MediumItem(medium));
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
class MediumItem extends StatelessWidget {
  MediumVO medium;

  MediumItem(this.medium);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.all(5.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            leading: Text(medium.date.substring(2),style:TextStyle(color:Colors.blue,fontSize: FontSize.NORMAL,fontWeight: FontWeight.bold,fontStyle:FontStyle.italic)),
            title:Text(medium.title,style:TextStyle(fontSize: FontSize.NORMAL)),
            subtitle: Row(
              children: [
                ClipOval(
                  child: ZJ_Image.network(medium.creatorIcon,
                      width: 20.0,
                      height: 20.0),
                ),
                Padding(padding: EdgeInsets.all(2.0)),
                Text(medium.creator,style:TextStyle(fontSize: FontSize.SUPER_SMALL), overflow: TextOverflow.ellipsis)
              ],
            ),
            trailing: Stack(
              alignment:AlignmentDirectional.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: ZJ_Image.network(medium.icon,width:95.0,height: 60)),
                Icon(medium.type == MediumEnum.VIDEO ? Icons.play_circle_outline : null,color:Colors.black.withOpacity(0.5))
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Header extends StatelessWidget {
  MyFocusVO focusVO;

  Header(this.focusVO);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.fromLTRB(10.0, 7.0, 10.0, 7.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0.0, 20.0), //阴影xy轴偏移量
                blurRadius: 30.0, //阴影模糊程度
                spreadRadius: 30.0 //阴影扩散程度
            )
          ]
      ),
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
                        ClipOval(child: ZJ_Image.network(focusVO.userIcon, width: 30.0, height: 30.0)),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Text(focusVO.userNickName, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white, fontSize: FontSize.NORMAL)),
                      ],
                    )
                  ])),
          Text("        " + focusVO.title, style: TextStyle(color: Colors.white), overflow: TextOverflow.clip),
          Divider(color: Colors.white.withOpacity(0.5)),
          Text(focusVO.strDate+ " ~ " + focusVO.endDate, style:TextStyle(color: Colors.white, fontSize: FontSize.SMALL)),
        ],
      ),
    );
  }
}
