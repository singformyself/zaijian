import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/model/AnnouncementVO.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class AnnouncementPage extends StatefulWidget {
  AnnouncementVO announcement;

  AnnouncementPage(this.announcement);

  @override
  State<StatefulWidget> createState() {
    return AnnouncementState(announcement);
  }
}

class AnnouncementState extends State<AnnouncementPage>{
  AnnouncementVO announcement;

  AnnouncementState(this.announcement);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar(''),
      body: Text(announcement.icon),
    );
  }
}