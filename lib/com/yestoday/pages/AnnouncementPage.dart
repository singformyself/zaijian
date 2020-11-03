import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnnouncementState();
  }
}

class AnnouncementState extends State<AnnouncementPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar(''),
      body: Text(''),
    );
  }
}