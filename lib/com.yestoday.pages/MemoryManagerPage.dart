import 'package:flutter/material.dart';

class MemoryManagerPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MemoryManagerPageState();
  }
}

class MemoryManagerPageState extends State<MemoryManagerPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("回忆管理"),
        ),
    );
  }
}