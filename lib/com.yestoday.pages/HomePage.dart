import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
  
}

class HomePageState extends State<HomePage> {
  List<Item> items = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.white,
        leading: Icon(Icons.brightness_low),
        actions: [Icon(Icons.menu)],
      ),
      body: ListView.builder(itemBuilder: (context, index){
        return items[index];
      }
      ,itemCount: items.length),
    );
  }

  @override
  void initState() {
    items = [
      Item(
          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600972320718&di=2ed809bb74414331395b9120cd6b7245&imgtype=0&src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202008%2F11%2F20200811231800_rqlkt.thumb.400_0.jpeg",
          "再见Atlantis",
          "记录一次国外旅行,东方时空的健康乐观看法来决定是否记得给的开始JFK大师傅但是",
          [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954957&di=2c0b1dda4267507f43cefb04149bc78a&imgtype=0&src=http%3A%2F%2Fimg8.zol.com.cn%2Fbbs%2Fupload%2F19372%2F19371631.JPG",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954957&di=885b1dd9e5c56bae8b6950c45f4ba558&imgtype=0&src=http%3A%2F%2Fbos.pgzs.com%2Frbpiczy%2FWallpaper%2F2011%2F9%2F1%2Fee1920d7340243b0b969ff16ae8fd6f0-11.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954955&di=fd4f215a9792f458c7a83be9ce4c968a&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fitbbs%2F1401%2F23%2Fc19%2F30819890_1390476198269_1024x1024it.jpg"
          ],
          "2016-12-26",
          "2020-09-24"),
      Item(
          "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=299548342,2048282219&fm=26&gp=0.jpg",
          "很傻很天真",
          "今年的春天，应该记录下来，待来年再见",
          [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954968&di=e56cf3340c07e46744746e1ef8300812&imgtype=0&src=http%3A%2F%2Fpic2.16pic.com%2F00%2F58%2F91%2F16pic_5891608_b.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954967&di=a1bf56a26bd374eacd8c69f311b90f06&imgtype=0&src=http%3A%2F%2Fpic.rmb.bdstatic.com%2F8c9625807e48f620a55127cdcd55e1f1.jpeg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600971954967&di=df07ba52a41118f66f426ded54bedf3c&imgtype=0&src=http%3A%2F%2Fimg8.zol.com.cn%2Fbbs%2Fupload%2F22597%2F22596740.jpg"
          ],
          "2016-12-26",
          "2020-09-24"),
      Item(
          "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=299548342,2048282219&fm=26&gp=0.jpg",
          "很傻很天真",
          "如果只有一个视频怎么办",
          [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600973110440&di=b0a7388479687da12825f900c06de24e&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1307%2F10%2Fc3%2F23153395_1373426315898.jpg"
          ],
          "2016-12-26",
          "2020-09-24"),
      Item(
          "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=299548342,2048282219&fm=26&gp=0.jpg",
          "很傻很天真",
          "那如果有2个视频呢",
          [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600973110440&di=190d2eebc5401c1d101bf271baa81ca5&imgtype=0&src=http%3A%2F%2Fyouimg1.c-ctrip.com%2Ftarget%2Ftg%2F677%2F141%2F975%2F31923de85bfc4eca8225f88368e45c67.jpg",
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600973110438&di=06bbf52af8f5900ec4ab19f9d0b1a58e&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7c71f336b7753e7f07fb7dc15ac9e91174fea275.jpg"
          ],
          "2016-12-26",
          "2020-09-24"),
    ];
  }
}

class Item extends StatelessWidget {
  String icon;
  String user;
  String title;
  List<String> images;
  String from;
  String to;

  Item(this.icon, this.user, this.title, this.images, this.from, this.to);

  @override
  Widget build(BuildContext context) {
    List<Expanded> sonItems = List();
    for (var value in images) {
      var temp = Expanded(
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox.expand(
                  child: Image(image: NetworkImage(value), fit: BoxFit.cover),
                ),
                IconButton(
                    onPressed:null,
                    icon: Icon(Icons.play_circle_outline, color: Colors.white,size: 30.0,))
      ]));
      sonItems.add(temp);
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white,boxShadow: [
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
                onPressed: null,
                padding: EdgeInsets.all(0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Row(
                        children: [
                          ClipOval(
                              child: Image(
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                                image: NetworkImage(icon),
                              )),
                          Padding(padding: EdgeInsets.all(3.0)),
                          Text(user,style: TextStyle(color: Colors.deepOrange)),
                        ],
                      ),
                      Icon(Icons.more_horiz)
                    ]
                )),
          ),
          Divider(),
          Text(title, textAlign: TextAlign.left, overflow: TextOverflow.clip),
          Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7.0)),
          AspectRatio(
            aspectRatio: _getAspectRatio(sonItems.length),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              //交叉轴的布局方式，对于column来说就是水平方向的布局方式
              crossAxisAlignment: CrossAxisAlignment.center,
              //就是字child的垂直布局方向，向上还是向下
              verticalDirection: VerticalDirection.down,
              children: sonItems,
            ),
          ),
          Divider(),
          Text("2016-09-20 ~ 2020-10-15",
              style: TextStyle(color: Colors.black38)),
        ],
      ),
    );
  }

  double _getAspectRatio(int length) {
    switch(length){
      case 3:return 16/10.0*3;
      case 2:return 16/10.0*2;
      case 1:return 16/10.0;
      default: break;
    }
    return length/1.0;
  }
}

