import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zaijian/com/yestoday/model/MediumVO.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'PhotoSwiperPage.dart';

class PhotoDetailPage extends StatefulWidget {
  MediumVO medium;
  PhotoDetailPage(this.medium);

  @override
  State<StatefulWidget> createState() {
    return PhotoDetailState(medium);
  }

}

class PhotoDetailState extends State<PhotoDetailPage>{
  MediumVO medium;
  PhotoDetailState(this.medium);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ZJ_AppBar(medium.title),
        body: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: medium.photos.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: ZJ_Image.network(medium.photos[index]),
            onTap: ()=>{
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PhotoSwiperPage(medium,index)))
            },
          ),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 2.0,
          crossAxisSpacing: 2.0,
        )
    );
  }
}