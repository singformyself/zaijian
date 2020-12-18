import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com/yestoday/model/AnnouncementVO.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/model/MyFocusVO.dart';
import 'package:zaijian/com/yestoday/pages/AnnouncementPage.dart';
import 'package:zaijian/com/yestoday/pages/config/Font.dart';
import 'package:zaijian/com/yestoday/service/HomepageService.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

import 'PhotoDetailPage.dart';
import 'MemoriesPage.dart';
import 'VideoPlayPage.dart';
import 'enum/ListViewActionEnum.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  // 获取服务器数据的service
  HomepageService service = new HomepageService();
  List<Widget> items = [];

  // 下拉刷新上拉加载控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: ZJ_AppBar("再见", actions: [Icon(Icons.menu)]),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.camera_alt)),
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
                  this.loadData(ListViewActionEnum.PULL_DOWN);
                },
                onLoading: () async {
                  this.loadMore();
                },
              ));
  }

  @override
  void initState() {
    super.initState();
    this.loadData(null);
  }

  void loadData(ListViewActionEnum action) {
    this.items = [];
    service.getAnnouncements().then((announcements) => {
          service.getMyFocus("userId").then((myFocus) => {
                this.setState(() {
                  this.updateAnnouncement(announcements);
                  this.updateMyFocus(myFocus, action);
                })
              })
        });
  }

  void loadMore() {
    service.getMyFocus("userId").then((myFocus) => {
          this.setState(() {
            this.updateMyFocus(myFocus, ListViewActionEnum.PULL_UP);
          })
        });
  }

  void updateAnnouncement(List<AnnouncementVO> announcements) {
    this.items.add(AspectRatio(
        aspectRatio: 16 / 9.0,
        child: Swiper(
            autoplay: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AnnouncementPage(announcements[index])));
                },
                child: ZJ_Image.network(announcements[index].icon)
              );
            },
            itemCount: announcements.length,
            pagination: SwiperPagination())));
  }

  void updateMyFocus(List<MyFocusVO> myFocus, ListViewActionEnum action) {
    myFocus.forEach((myFocusVO) {
      this.items.add(MyFocus(myFocusVO));
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

class MyFocus extends StatelessWidget {
  MyFocusVO myFocus;

  MyFocus(this.myFocus);

  @override
  Widget build(BuildContext context) {
    List<Expanded> sonItems = List();
    for (var medium in myFocus.showItems) {
      var temp = Expanded(
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
        SizedBox.expand(
          child: GestureDetector(
            onTap: () => {
              if (medium.type==MediumEnum.VIDEO) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => VideoPlayPage(medium)))
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PhotoDetailPage(medium)))
              }
            },
            child: Container(
              padding: EdgeInsets.all(1.0),
              child: ZJ_Image.network(medium.icon),
            ), //
          ),
        ),
        Icon(
            medium.type == MediumEnum.VIDEO
                ? Icons.play_circle_outline
                : Icons.photo,
            color: Colors.black.withOpacity(0.5))
      ]));
      sonItems.add(temp);
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(bottom: 3.0),
      padding: EdgeInsets.fromLTRB(3.0, 7.0, 3.0, 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30.0,
            child: FlatButton(
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MemoriesPage(myFocus)))
                    },
                padding: EdgeInsets.all(0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: ZJ_Image.network(myFocus.userIcon,
                                width: 30.0, height: 30.0),
                          ),
                          Padding(padding: EdgeInsets.all(3.0)),
                          Text(myFocus.userNickName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: FontSize.NORMAL)),
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ])),
          ),
          Divider(),
          Text("        " + myFocus.title,
              overflow: TextOverflow.clip,
              style: TextStyle(fontSize: FontSize.NORMAL)),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.0)),
          AspectRatio(
            aspectRatio: _getAspectRatio(sonItems.length),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: sonItems,
            ),
          ),
          Divider(),
          Text(myFocus.strDate + " ~ " + myFocus.endDate,
              style:
                  TextStyle(color: Colors.black54, fontSize: FontSize.SMALL)),
        ],
      ),
    );
  }

  double _getAspectRatio(int length) {
    switch (length) {
      case 3:
        return 16 / 10.0 * 3;
      case 2:
        return 16 / 10.0 * 2;
      case 1:
        return 16 / 9.0;
      default:
        break;
    }
    return length / 1.0;
  }
}
