import 'package:flutter/material.dart';
import 'package:zaijian/com.yestoday.pages/HomePage.dart';
import 'package:zaijian/com.yestoday.pages/MePage.dart';
import 'package:zaijian/com.yestoday.pages/MemoryManagerPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '再见',
      theme: ThemeData(brightness: Brightness.light),
      home: NavigationFrame(),
    );
  }
}

class NavigationFrame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationFrameState();
  }
}

class NavigationFrameState extends State<NavigationFrame> {
  int currentTabIndex = 0;
  List<Widget> pages = [HomePage(), MemoryManagerPage(), MePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 24.0,
          selectedFontSize: 12.0,
          currentIndex: currentTabIndex,
          onTap: (index) {
            this._changePage(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页", style:TextStyle(fontSize: 12.0))),
            BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("回忆管理", style:TextStyle(fontSize: 12.0))),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("我的", style:TextStyle(fontSize: 12.0)))
          ],
          type: BottomNavigationBarType.fixed)
    );
  }

  void _changePage(int index) {
    if (index != currentTabIndex) {
      setState(() {
        currentTabIndex = index;
      });
    }
  }
}
