import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadPhotoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UploadPhotoState();
  }
}

class UploadPhotoState extends State<UploadPhotoPage>{
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("上传照片"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          // TODO submit
        },
      ),
      body:Form(
        key:formKey1,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入回忆名称";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.camera),
                  hintText: '编辑回忆名称',
                ),
              ),
            ),
            OutlinedButton(
              child: Text("选择照片",style: TextStyle(color:Theme.of(context).primaryColor)),
              onPressed: loadAssets,
            ),
            Expanded(
              child: Container(
                padding:EdgeInsets.all(10),
                child: buildGridView(),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          padding:EdgeInsets.all(0.5),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
              IconButton(
                padding:EdgeInsets.all(0.5),
                alignment: Alignment.topRight,
                icon: Icon(Icons.delete,color:Colors.white.withOpacity(0.5)),
                onPressed: ()=>{
                  this.setState(() {
                    images.removeAt(index);
                  })
                },
              )
            ],
          )
        );
      }),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 50,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "选择照片",
          allViewTitle: "全部照片",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
  @override
  void initState() {
    super.initState();
  }
}