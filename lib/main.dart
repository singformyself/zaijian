import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'com/yestoday/pages/HomePage.dart';
import 'com/yestoday/pages/MePage.dart';
import 'com/yestoday/pages/MemoryListPage.dart';

void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // 每次启动都会刷新一次token
  TokenApi.refresh();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '再见',
      theme: ThemeData(brightness: Brightness.light,focusColor: Colors.blueGrey,hoverColor: Colors.blueGrey),
      home: NavigationFrame(),
      builder: EasyLoading.init()
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
  List<Widget> pages = [HomePage(), MemoryListPage(), MePage()];

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
            BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text("我的回忆", style:TextStyle(fontSize: 12.0))),
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

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..toastPosition = EasyLoadingToastPosition.top
      ..indicatorType = EasyLoadingIndicatorType.fadingFour
      ..loadingStyle = EasyLoadingStyle.custom
      ..radius = 8
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black.withOpacity(0.5)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5);
  }
}
