import 'package:extended_image/extended_image.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/model/MemoryVO.dart';
import 'package:zaijian/com/yestoday/pages/UploadPhotoPage.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:zaijian/com/yestoday/widget/common_widget.dart';

import 'config/Font.dart';

/**
 * 回忆管理页面，展示回忆详情，回忆见证人，图片上传，视频上传
 */
class MemoryManagementPage extends StatefulWidget {
  MemoryVO memory;


  MemoryManagementPage(this.memory);

  @override
  State<StatefulWidget> createState() {
    return MemoryManagementState(memory);
  }

}

class MemoryManagementState extends State<MemoryManagementPage> with SingleTickerProviderStateMixin{
  MemoryVO memory;
  List<Eyewitness> eyewitness=[Eyewitness(),Eyewitness(),Eyewitness()];
  Animation<double> _animation;
  AnimationController _animationController;

  MemoryManagementState(this.memory);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment:Alignment.topCenter,
                image: ExtendedNetworkImageProvider('https://zaijian.obs.cn-north-4.myhuaweicloud.com/kjlhfghfdsdfdgf.jpg', cache:true),fit: BoxFit.fitWidth)),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            appBar: AppBar(backgroundColor: Colors.transparent, elevation:0.0),
            body: Column(
              children: [
                Header(memory),
                Container(
                  padding:EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text("见证人：10",style:TextStyle(fontSize: FontSize.LARGE)),
                      Padding(padding: EdgeInsets.all(20),),
                      Text("回忆：100",style:TextStyle(fontSize: FontSize.LARGE)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return eyewitness[index];
                        },
                        itemCount: eyewitness.length,
                      )
                  ),
                )
              ],
            ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              // Floating action menu item
              Bubble(
                title:"照片",
                iconColor :Colors.white,
                bubbleColor : Theme.of(context).primaryColor,
                icon:Icons.file_upload,
                titleStyle:TextStyle(fontSize: FontSize.NORMAL  , color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UploadPhotoPage()));
                },
              ),
              //Floating action menu item
              Bubble(
                title:"视频",
                iconColor :Colors.white,
                bubbleColor : Theme.of(context).primaryColor,
                icon:Icons.file_upload,
                titleStyle:TextStyle(fontSize: FontSize.NORMAL , color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                },
              ),
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: Colors.white,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: Theme.of(context).primaryColor,
          ),
        )
    );
  }
  @override
  void initState(){

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();


  }
}

class Eyewitness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12))
      ),
      padding:EdgeInsets.all(10.0),
      child: Row(
        children: [
          ClipOval(
            child: ZJ_Image.network("https://zaijian.obs.cn-north-4.myhuaweicloud.com/kjhjhhgfsgg.jpg",
                width: 30.0, height: 30.0),
          ),
          Padding(padding: EdgeInsets.all(3.0)),
          Text("myFocus.userNickName",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: FontSize.NORMAL)),
          Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                child: Text("20",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: FontSize.NORMAL))
            )
          )
        ],
      )
    );
  }
}

class Header extends StatelessWidget {
  MemoryVO memory;

  Header(this.memory);

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
                        ClipOval(child: ZJ_Image.network(memory.creatorIcon, width: 30.0, height: 30.0)),
                        Padding(padding: EdgeInsets.all(3.0)),
                        Text(memory.creator, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white, fontSize: FontSize.NORMAL)),
                      ],
                    )
                  ])),
          Text("        " + memory.title, style: TextStyle(color: Colors.white), overflow: TextOverflow.clip),
          Divider(color: Colors.white.withOpacity(0.5)),
          Text(memory.date, style:TextStyle(color: Colors.white, fontSize: FontSize.SMALL)),
        ],
      ),
    );
  }
}