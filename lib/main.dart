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
      title: 'zaijian',
      theme:
          ThemeData(brightness: Brightness.light, primaryColor: Colors.deepOrange),
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
      backgroundColor: Color.fromRGBO(0xEE, 0xEE, 0xEE, 1),
//      appBar: AppBar(
//          leading: Padding(
//            padding: EdgeInsets.fromLTRB(7.0, 7.0, 0, 7.0),
//            child: ClipOval(child: Image.asset("images/logo.png"),),
//          ),
//          title: Text("再见"),
//          centerTitle: true),
      body: pages[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12.0,
          currentIndex: currentTabIndex,
          onTap: (index) {
            this._changePage(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页", style:TextStyle(fontSize: 12.0))),
            BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("回忆管理", style:TextStyle(fontSize: 12.0))),
            BottomNavigationBarItem(icon: Icon(Icons.perm_identity), title: Text("我的", style:TextStyle(fontSize: 12.0)))
          ],
          type: BottomNavigationBarType.fixed),
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
