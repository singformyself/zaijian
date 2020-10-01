import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com.yestoday.model/AnnouncementVO.dart';
import 'package:zaijian/com.yestoday.model/MediumVO.dart';
import 'package:zaijian/com.yestoday.model/MyFocusVO.dart';
import 'package:zaijian/com.yestoday.service/HomepageService.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  HomepageService homepageService = new HomepageService();
  AspectRatio aspectRatio;
  List<AnnouncementVO> announcement = [];
  List<MyFocusVO> myFocus = [];
  List<Widget> items = [];
  ScrollController scrollController = ScrollController(); //listview的控制器
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
        body: items.length == 0
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return items[index];
                    },
                    itemCount: items.length,
                    controller: scrollController
                ),
              )
    );
  }

  @override
  void initState() {
    super.initState();
    this._loadData();
    this.scrollController.addListener(() {
      print(scrollController.position);
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
      }
    });
  }

  Future _loadData() async {
    this.items=[];
    homepageService
        .getAnnouncements()
        .then((announcements) => this.announcement = announcements)
        .whenComplete(() => this.setState(() {
      this.items.add(AspectRatio(
          aspectRatio: 16 / 9.0,
          child: Swiper(
              autoplay: true,
              itemBuilder: (context, index) {
                return Image.network(announcement[index].imageUrl,
                    fit: BoxFit.cover);
              },
              itemCount: announcement.length,
              pagination: SwiperPagination())));
    }));
    homepageService
        .getMyFocus("userId")
        .then((myFocus) => this.myFocus = myFocus)
        .whenComplete(() => this.setState(() {
      this.myFocus.forEach((myFocusVO) {
        this.items.add(MyFocus(myFocusVO));
      });
    }));
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
          child: Image(image: NetworkImage(medium.icon), fit: BoxFit.cover),
        ),
        IconButton(
            onPressed: () => {Toast.show("打开详情页面", context)},
            icon: Icon(
                medium.type == MediumEnum.VIDEO
                    ? Icons.play_circle_outline
                    : Icons.photo,
                color: Colors.white54,
                size: 30.0))
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
