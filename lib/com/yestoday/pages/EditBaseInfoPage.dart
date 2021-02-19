import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaijian/com/yestoday/widget/ZJ_AppBar.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';

class EditBaseInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditBaseInfoState();
  }
}

class EditBaseInfoState extends State<EditBaseInfoPage> {
  dynamic user;
  static const int sex = 2;
  TextEditingController nameController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZJ_AppBar("编辑个人信息"),
      floatingActionButton: FloatingActionButton(
        child: Text("确定"),
        onPressed: () {
          submit(nameController.text, context);
        },
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 50, 5, 100),
            child: ListView(
              children: [
                Container(
                  child: TextFormField(
                    autofocus: false,
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "请输入昵称";
                      }
                      if (value.length > 16) {
                        return "不能超过16个字符";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Text('昵称'),
                      hintText: '请输入昵称',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text("性别"),
                    Radio(
                      value: 1,
                      groupValue: user != null ? user['sex'] : sex,
                      onChanged: (value) {
                        this.setState(() {
                          this.user['sex'] = value;
                        });
                      },
                    ),
                    Text("男"),
                    Radio(
                      value: 0,
                      groupValue: user != null ? user['sex'] : sex,
                      onChanged: (value) {
                        this.setState(() {
                          this.user['sex'] = value;
                        });
                      },
                    ),
                    Text("女"),
                    Radio(
                      value: 2,
                      groupValue: user != null ? user['sex'] : sex,
                      onChanged: (value) {
                        this.setState(() {
                          this.user['sex'] = value;
                        });
                      },
                    ),
                    Text("秘密"),
                  ],
                ),
                Row(
                  children: [
                    Text("生日"),
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(14, 12, 0, 10),
                      child: Text(user==null?"":user['birthDay'],
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: FontSize.LARGE)),
                      onPressed: () {
                        MyPicker.showPicker(
                          context: context,
                          current: DateTime.now(),
                          mode: MyPickerMode.date,
                          onConfirm: (val) => {
                            this.setState(() {
                              user['birthDay'] = formatDate(val, [yyyy, '-', mm, '-', dd]);
                            })
                          },
                        );
                      },
                    ),
                    // Expanded(child: DateTime),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    getUser();
  }
  Future<void> getUser() async {
    user = await MyUtil.getUser();
    nameController = TextEditingController(text: user['nickName']);
    this.setState(() {});
  }
  void submit(String nickName, BuildContext context) {
    UserApi.updateInfo(user['id'],nickName,user['sex'],user['birthDay']).then((rsp) async {
      if(rsp[KEY.SUCCESS]){
        EasyLoading.showSuccess('修改成功');
        await Future.delayed(Duration(milliseconds: 2000));
        Navigator.pop(context, rsp[KEY.USER]);
      }
    });
  }
}
