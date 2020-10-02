import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com.yestoday.model/AnnouncementVO.dart';
import 'package:zaijian/com.yestoday.model/MediumVO.dart';
import 'package:zaijian/com.yestoday.model/MyFocusVO.dart';
import 'package:zaijian/com.yestoday.pages/enum/ListViewActionEnum.dart';
import 'package:zaijian/com.yestoday.service/HomepageService.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  HomepageService _homepageService = new HomepageService();

//  List<AnnouncementVO> _announcement = [];
//  List<MyFocusVO> _myFocus = [];
  List<Widget> _items = [];
  RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBar(
              title: Text("再见"),
              actions: [Icon(Icons.menu)],
            ),
            preferredSize: Size.fromHeight(50.0)),
        body: _items.length == 0
            ? Center(child: CircularProgressIndicator())
            : SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          header: WaterDropHeader(waterDropColor: Colors.blue),
          footer: ClassicFooter(
            loadStyle: LoadStyle.ShowWhenLoading,
            completeDuration: Duration(milliseconds: 500),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _items[index];
            },
            itemCount: _items.length,
          ),
          onRefresh: () async {
            this._loadData(ListViewActionEnum.PULL_DOWN);
          },
          onLoading: () async {
            this._loadMore();
          },
        )
    );
  }

  @override
  void initState() {
    super.initState();
    this._loadData(null);
  }

  void _loadData(ListViewActionEnum action) {
    this._items = [];
    _homepageService.getAnnouncements().then((announcements) =>
    {
      _homepageService.getMyFocus("userId").then((myFocus) =>
      {
        this.setState(() {
          this._updateAnnouncement(announcements);
          this._updateMyFocus(myFocus,action);
          this._refreshController.refreshCompleted();
        })
      })
    });
//    _homepageService
//        .getAnnouncements()
//        .then((announcements) => this._announcement = announcements)
//        .whenComplete(() => this.setState(() {
//      this._items.add(AspectRatio(
//          aspectRatio: 16 / 9.0,
//          child: Swiper(
//              autoplay: true,
//              itemBuilder: (context, index) {
//                return Image.network(_announcement[index].imageUrl,
//                    fit: BoxFit.cover);
//              },
//              itemCount: _announcement.length,
//              pagination: SwiperPagination())));
//    }));
//    _homepageService
//        .getMyFocus("userId")
//        .then((myFocus) => this._myFocus = myFocus)
//        .whenComplete(() => this.setState(() {
//          this._myFocus.forEach((myFocusVO) {
//          this._items.add(MyFocus(myFocusVO));
//          this._refreshController.refreshCompleted();
//      });
//    }));
  }

  void _loadMore() {
    _homepageService
        .getMyFocus("userId")
        .then((myFocus) => {
          this.setState(() {
            this._updateMyFocus(myFocus,ListViewActionEnum.PULL_UP);
          })
        });
  }

  void _updateAnnouncement(List<AnnouncementVO> announcements) {
    this._items.add(AspectRatio(
        aspectRatio: 16 / 9.0,
        child: Swiper(
            autoplay: true,
            itemBuilder: (context, index) {
              return Image.network(announcements[index].imageUrl,
                  fit: BoxFit.cover);
            },
            itemCount: announcements.length,
            pagination: SwiperPagination())));
  }

  void _updateMyFocus(List<MyFocusVO> myFocus, ListViewActionEnum action) {
    myFocus.forEach((myFocusVO) {
      this._items.add(MyFocus(myFocusVO));
    });
    switch(action){
      case ListViewActionEnum.PULL_DOWN: this._refreshController.refreshCompleted();break;
      case ListViewActionEnum.PULL_UP: this._refreshController.loadComplete();break;
      default: break;
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
          child: Stack(alignment: AlignmentDirectional.center, children: [
            SizedBox.expand(
              child: Container(
                padding: EdgeInsets.all(1.0),
                child: Image(image: NetworkImage(medium.icon), fit: BoxFit.cover),
              ),//
            ),
            IconButton(
                iconSize: medium.type == MediumEnum.VIDEO? 30.0: 90.0,
                onPressed: () => {Toast.show("打开详情页面", context)},
                icon: Icon(
                    medium.type == MediumEnum.VIDEO
                        ? Icons.play_circle_outline
                        : null,
                    color: Colors.white54,
                    ))
          ]));
      sonItems.add(temp);
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5.0,
        ),
      ]),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
      padding: EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30.0,
            child: FlatButton(
                onPressed: () => {Toast.show("打开更多页面", context)},
                padding: EdgeInsets.all(0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                              child: Image(
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                                image: NetworkImage(myFocus.userIcon),
                              )),
                          Padding(padding: EdgeInsets.all(3.0)),
                          Text(myFocus.userNickName, style: TextStyle()),
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ])),
          ),
          Divider(),
          Text(myFocus.title,
              textAlign: TextAlign.left, overflow: TextOverflow.clip),
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
              style: TextStyle(color: Colors.black38, fontSize: 12.0)),
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
