import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';
import 'package:zaijian/com/yestoday/pages/EditCoverPage.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_Image.dart';
import 'config/Font.dart';

class ModifyMemoryPage extends StatefulWidget {
  dynamic memory;
  ModifyMemoryPage(this.memory);
  @override
  State<StatefulWidget> createState() {
    return ModifyMemoryState(memory);
  }
}

class ModifyMemoryState extends State<ModifyMemoryPage> {
  dynamic memory;
  ModifyMemoryState(this.memory);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  List<int> coverBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("修改主题"),
      floatingActionButton: FloatingActionButton(
          child: Text("确定"),
          onPressed: () {
            submit(nameController.text, context);
          }),
      body: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  maxLines: 2,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "请输入主题名称";
                    }
                    if (value.length > 128) {
                      return "主题名称不能超过128个字符";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.camera),
                    hintText: '请输入主题名称',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("可见状态", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<bool>(
                      value: true,
                      groupValue: memory['publicity'],
                      onChanged: (value) {
                        this.setState(() {
                          memory['publicity'] = value;
                        });
                      },
                    ),
                    Text("公开", style: TextStyle(fontSize: FontSize.NORMAL)),
                    Radio<bool>(
                      value: false,
                      groupValue: memory['publicity'],
                      onChanged: (value) {
                        this.setState(() {
                          memory['publicity'] = value;
                        });
                      },
                    ),
                    Text("私藏", style: TextStyle(fontSize: FontSize.NORMAL)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("封面"),
                    Padding(padding: EdgeInsets.all(10)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: coverBytes != null
                          ? ExtendedImage.memory(coverBytes,
                          width: 95, height: 60, fit: BoxFit.cover)
                          : ZJ_Image.network(MyApi.OBS_HOST + memory['icon'],
                        width: 95,
                        height: 60,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    OutlineButton(
                      child: Text("设置封面",
                          style:
                          TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () async {
                        List<int> bytes = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditCoverPage(defaultCover:MyApi.OBS_HOST + memory['icon'])));
                        if (bytes != null) {
                          this.setState(() {
                            coverBytes = bytes;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 300))
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: memory['title']);
  }

  Future<void> submit(String text, BuildContext context) async {
    // 优先上传图片到obs，图片上传成功，返回路径名称，再存储数据到服务器
    if (coverBytes!=null) {
      String month = formatDate(DateTime.now(), [yyyy, '-', mm]);
      String name = "cover/"+month+"/"+Uuid().v4() + ".jpg";
      bool success = await OBSApi.uploadObsBytes(name, coverBytes);
      if (success) {
        memory['icon']="/"+name;
      }
    }
    memory['title'] = nameController.text;
    MemoryApi.save(memory).then((rsp) async {
      if (rsp[KEY.SUCCESS]) {
        EasyLoading.showSuccess("修改成功");
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.pop(context, true);
      } else {
        EasyLoading.showError(rsp[KEY.MSG]);
      }
    });
  }
}
