import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:okhttp_kit/okhttp3/http_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import 'package:zaijian/com/yestoday/service/MyApi.dart';

class MyTask {
  static const String TASK_KEY = 'uploadTask';
  static MyTask instance = MyTask();
  bool isRunning = false;
  Map<String, ProgressStatus> progressCache = HashMap(); // 存储上传进度key=itemId
  UploadTask runningTask; // 当前正在上传的任务
  void addTask(UploadTask task) async {
    SharedPreferences.getInstance().then((stg) {
      List<String> tasks = stg.getStringList(TASK_KEY);
      if (tasks == null || tasks.isEmpty) {
        tasks = [];
      }
      tasks.add(json.encode(task));
      stg.setStringList(TASK_KEY, tasks);
      start();
    });
  }

  Future<UploadTask> getNextTask() async {
    SharedPreferences stg = await SharedPreferences.getInstance();
    List<String> tasks = stg.getStringList(TASK_KEY);
    if (tasks != null && tasks.isNotEmpty) {
      String next = tasks.elementAt(0); //拿第一个任务出来
      return UploadTask.fromJson(json.decode(next));
    }
    return null;
  }

  Future<String> compress(String filePath) async {
    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );
    return mediaInfo.path;
  }

  ProgressStatus getProgressValue(String key) {
    return progressCache[key];
  }

  void listenProgress(
      HttpUrl url, int progressBytes, int totalBytes, bool isDone) async {
    String path = url.toString();
    // 只有上传视频和照片时候才会监听进度,进度将会被存入临时内存里
    if ((path.contains('/video/') || path.contains('/photo/')) && runningTask != null) {
      double percent = (runningTask.now + progressBytes) * 100 / runningTask.totalBytes;
      progressCache.update(runningTask.itemId, (value) => ProgressStatus(1, percent),
          ifAbsent: () => ProgressStatus(1, percent));
      if (isDone) {
        runningTask.now += totalBytes;
      }
    }
  }

  Future<void> removeFinish(String key) async {
    Future.delayed(Duration(seconds: 2))
        .then((value) => progressCache.remove(key));
    // 如果成功运行到这一步，移除异常存储里的任务
    SharedPreferences stg = await SharedPreferences.getInstance();
    List<String> tasks = stg.getStringList(TASK_KEY);
    if (tasks != null && tasks.isNotEmpty) {
      // 如果成功，移除第一个任务
      tasks.removeAt(0);
      stg.setStringList(TASK_KEY, tasks);
    }
  }

  Future<void> start() async {
    if (isRunning) {
      return;
    }
    isRunning = true;
    // 订阅一下
    Subscription _subscription;
    try {
      _subscription = VideoCompress.compressProgress$.subscribe((progress) {
        // progress是已经乘以100的
        progressCache.update(
            runningTask.itemId, (value) => ProgressStatus(-1, progress),
            ifAbsent: () => ProgressStatus(-1, progress));
      });
      while ((runningTask = await getNextTask()) != null) {
        // 从0等待上传 改为 1上传中
        MemoryApi.updateMemoryItemStatus(runningTask.itemId, 1);
        List<UploadObject> objs = runningTask.uploadObjects;
        for (int i = 0; i < objs.length; i++) {
          UploadObject item = objs.elementAt(i);
          File file = File(item.filePath);
          if (runningTask.type == 0) {
            // 视频需要先压缩
            String path = await compress(item.filePath);
            file = File(path);
          }
          if (file.existsSync()) {
            await OBSApi.uploadFile(item.objectId, file);
          }
        }
        // 上传完成，更新memoryItemDoc的状态为 9 完成
        await MemoryApi.updateMemoryItemStatus(runningTask.itemId, 9);
        progressCache.update(
            runningTask.itemId, (value) => ProgressStatus(9, 100),
            ifAbsent: () => ProgressStatus(9, 100));
        removeFinish(runningTask.itemId);
        if (runningTask.type == 0) {
          VideoCompress.deleteAllCache();
        }
      }
    } catch (e) {
      print(e);
    } finally {
      runningTask = null;
      isRunning = false;
      _subscription.unsubscribe();
    }
  }
}

/*任务会存入sharestorage里持久化，通过定时任务，处理未完成的task*/
class UploadTask {
  int type; // 0 视频  1照片  视频需要压缩
  String itemId; //回忆项id
  List<UploadObject> uploadObjects;
  int totalBytes;
  int now = 0; // 当前上传的量

  Map toJson() {
    Map map = Map();
    map['type'] = type;
    map['itemId'] = itemId;
    map['totalBytes'] = totalBytes;
    var arr = [];
    for (var value in uploadObjects) {
      arr.add(value.toJson());
    }
    map['uploadObjects'] = arr;
    return map;
  }

  UploadTask.name(this.type, this.itemId, this.uploadObjects, this.totalBytes);

  UploadTask(
      int type, String itemId, List<dynamic> uploadObjects, int totalBytes) {
    this.type = type;
    this.itemId = itemId;
    this.totalBytes = totalBytes;
    List<UploadObject> objs = [];
    for (var value in uploadObjects) {
      objs.add(UploadObject.fromJson(value));
    }
    this.uploadObjects = objs;
    this.now = 0;
  }

  factory UploadTask.fromJson(Map<String, dynamic> json) {
    return UploadTask(json['type'] as int, json['itemId'] as String,
        json['uploadObjects'] as List<dynamic>, json['totalBytes'] as int);
  }
}

class UploadObject {
  String objectId;
  String filePath;

  Map toJson() {
    Map map = Map();
    map['objectId'] = objectId;
    map['filePath'] = filePath;
    return map;
  }

  UploadObject(this.objectId, this.filePath);

  factory UploadObject.fromJson(Map<String, dynamic> json) {
    return UploadObject(json['objectId'] as String, json['filePath'] as String);
  }
}

class ProgressStatus {
  int status = 0; //-1正在压缩，0等待上传，1正在上传，9上传完成
  double value;

  ProgressStatus(this.status, this.value);
}
