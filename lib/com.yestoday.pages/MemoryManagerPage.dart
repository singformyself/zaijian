import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zaijian/com.yestoday.service/MemoryManagerPageService.dart';
import 'package:zaijian/com.yestoday.widget/ZJ_AppBar.dart';

class MemoryManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MemoryManagerPageState();
  }
}

class MemoryManagerPageState extends State<MemoryManagerPage> {
  MemoryManagerPageService service = new MemoryManagerPageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("回忆管理", [Icon(Icons.menu)]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Toast.show("添加新的回忆录", context);
        },
      ),
      body: Center(
        child: Text("回忆管理"),
      ),
    );
  }
}
