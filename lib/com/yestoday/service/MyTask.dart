import 'dart:convert';
import 'dart:io';
import 'package:okhttp_kit/okhttp3/http_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';

class MyTask {
  static const String TASK_KEY='uploadTask';
  static MyTask instance = MyTask();
  bool isRunning=false;

  void addTask(UploadTask task) async {
    SharedPreferences stg = await SharedPreferences.getInstance();
    List<String> tasks = stg.getStringList(TASK_KEY);
    if (tasks==null||tasks.isEmpty) {
      tasks=[];
    }
    tasks.add(json.encode(task));
    stg.setStringList(TASK_KEY, tasks);
  }

  Future<UploadTask> getNextTask() async {
    SharedPreferences stg = await SharedPreferences.getInstance();
    List<String> tasks = stg.getStringList(TASK_KEY);
    if (tasks!=null&&tasks.isNotEmpty) {
      String next = tasks.removeLast();
      return UploadTask.fromJson(json.decode(next));
    }
  }

  static void listenProgress(
      HttpUrl url, int progressBytes, int totalBytes, bool isDone) async {
    String path = url.toString();
    // 只有上传视频和照片时候才会监听进度
    if (path.contains('/video/') || path.contains('/photo/')) {}
  }

  Future<void> start() async {
    if (isRunning) {
      return;
    }
    isRunning = true;
    UploadTask nextTask;
    while ((nextTask = await getNextTask()) != null) {
      // 从0等待上传 改为 1上传中
      MemoryApi.updateMemoryItemStatus(nextTask.itemId, 1);
      List<UploadObject> objs = nextTask.uploadObjects;
      for (int i = 0; i < objs.length; i++) {
        UploadObject item = objs.elementAt(i);
        File file = File(item.filePath);
        if (file.existsSync()) {
          await OBSApi.uploadFile(item.objectId, file);
        }
      }
      // 上传完成，更新memoryItemDoc的状态为 9 完成
      MemoryApi.updateMemoryItemStatus(nextTask.itemId, 9);
    }
    isRunning = false;
  }
}

/*任务会存入sharestorage里持久化，通过定时任务，处理未完成的task*/
class UploadTask {
  String itemId; //回忆项id
  List<UploadObject> uploadObjects;
  int totalBytes;

  Map toJson(){
    Map map = Map();
    map['itemId']=itemId;
    map['totalBytes']=totalBytes;
    var arr = [];
    for (var value in uploadObjects) {
      arr.add(value.toJson());
    }
    map['uploadObjects']=arr;
    return map;
  }

  UploadTask(String itemId, List<dynamic> uploadObjects, int totalBytes){
    this.itemId = itemId;
    this.totalBytes = totalBytes;
    List<UploadObject> objs = [];
    for (var value in uploadObjects) {
      objs.add(UploadObject.fromJson(value));
    }
    this.uploadObjects = objs;
  }

  factory UploadTask.fromJson(Map<String,dynamic> json){
    return UploadTask(json['itemId'] as String,json['uploadObjects'] as List<dynamic>,json['totalBytes'] as int);
  }
}

class UploadObject {
  String objectId;
  String filePath;
  Map toJson(){
    Map map = Map();
    map['objectId']=objectId;
    map['filePath']=filePath;
    return map;
  }
  UploadObject(this.objectId, this.filePath);

  factory UploadObject.fromJson(Map<String,dynamic> json){
    return UploadObject(json['objectId'] as String,json['filePath'] as String);
  }
}
