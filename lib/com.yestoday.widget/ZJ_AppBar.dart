import 'package:flutter/material.dart';

/**
 * appbar组件
 */
class ZJ_AppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
  List<Widget> actions;

  ZJ_AppBar(this.title, this.actions);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          title: Text(title),
          actions: [Icon(Icons.menu)],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}