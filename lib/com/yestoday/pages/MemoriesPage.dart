import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaling_header/scaling_header.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';

class MemoriesPage extends StatefulWidget {
  String id;
  String title;
  String userIcon;
  String userNickName;

  MemoriesPage(this.id, this.title, this.userIcon, this.userNickName);

  @override
  State<StatefulWidget> createState() {
    return MemoriesState(this.id, this.title, this.userIcon, this.userNickName);
  }
}

class MemoriesState extends State<MemoriesPage> {
  String id;
  String title;
  String userIcon;
  String userNickName;

  MemoriesState(this.id, this.title, this.userIcon, this.userNickName);

  final double overlapContentHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: <Widget>[
          ScalingHeader(
            backgroundColor: Theme.of(context).primaryColor,
            title: Container(
              padding: EdgeInsets.fromLTRB(20.0,5.0,20.0,5.0),
              child: TextField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    filled: true,
                    focusColor: Colors.white.withOpacity(0.5),
                    fillColor: Colors.white.withOpacity(0.5),
                    disabledBorder: null,
                    border: null,
                    suffixIcon: Icon(Icons.search,color: Colors.white,)
                ),
              )
            ),
            flexibleSpace: ZJ_Image.network(
              'https://zaijian.obs.cn-north-4.myhuaweicloud.com/gfgfdhggjgf0.jpg',
              color: Colors.black.withOpacity(0.2),
              colorBlendMode: BlendMode.srcATop,
            ),
            overlapContentBackgroundColor: Theme.of(context).primaryColor,
            overlapContent: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Tap Bio');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chrome_reader_mode,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Read Bio',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Tap Movies');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.devices,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text('See Movies',
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 0, right: 16, left: 16, bottom: 16),
              child: Text(
                'James Dean was born on February 8, 1931, in Marion, Indiana. '
                        'He starred in the film adaptation of the John Steinbeck novel '
                        'East of Eden, for which he received a posthumous Oscar '
                        'nomination. Dean\'s next starring role as an emotionally '
                        'tortured teen in Rebel Without a Cause made him into the '
                        'embodiment his generation. In early autumn 1955, Dean was killed '
                        'in a car crash, quickly becoming an enduring film icon whose '
                        'legacy has endured for decades. His final film Giant, was also '
                        'released posthumously.\n\n' *
                    50,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
