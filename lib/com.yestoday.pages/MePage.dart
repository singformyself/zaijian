import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: FlatButton(onPressed: ()=>{Toast.show("fkdfjkdsjfd", context)}, child:Text("fdkfjdksjfdsk")),
    );
  }
//  @override
//  State<StatefulWidget> createState() {
//    return MePageState();
//  }
}

//class MePageState extends State<MePage>{
//  @override
//  Widget build(BuildContext context) {
//    return Text("我的");
//  }
//}