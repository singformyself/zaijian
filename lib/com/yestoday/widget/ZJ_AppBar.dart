import 'package:flutter/material.dart';

/**
 * appbar组件
 */
class ZJ_AppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
  List<Widget> actions;
  PreferredSizeWidget bottom;
  ZJ_AppBar(this.title, {this.actions, this.bottom});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          title: Text(title,overflow: TextOverflow.ellipsis),
          actions: actions,
          bottom: bottom,
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}