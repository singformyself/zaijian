import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:okhttp_kit/okhttp3/form_body.dart';
import 'package:okhttp_kit/okhttp3/okhttp_client.dart';
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';
import 'package:zaijian/com/yestoday/service/MyTask.dart';

class KEY {
  static const String TOKEN = "token";
  static const String USER = "user";
  static const String USER_ID = "id";
  static const String SUCCESS = "success";
  static const String MSG = "msg";
}

class FontSize {
  static const double SUPER_LARGE = 18.0;
  static const double LARGE = 16.0;
  static const double NORMAL = 14.0;
  static const double SMALL = 12.0;
  static const double SUPER_SMALL = 10.0;
}

class MyUtil {
  static void cleanStorage() {
    SharedPreferences.getInstance().then((stg) {
      stg.clear();
    });
  }

  static Future<dynamic> getUser() async {
    SharedPreferences stg = await SharedPreferences.getInstance();
    String user = stg.getString(KEY.USER);
    return json.decode(user);
  }

  static Future<dynamic> getUserId() async {
    SharedPreferences stg = await SharedPreferences.getInstance();
    return stg.getString(KEY.USER_ID);
  }

  static String genCoverName() {
    String month = formatDate(DateTime.now(), [yyyy, '-', mm]);
    return "cover/" + month + "/" + Uuid().v4().replaceAll('-', '') + ".jpg";
  }

  static String genVideoName(String filePath) {
    String month = formatDate(DateTime.now(), [yyyy, '-', mm]);
    return "video/" +
        month +
        "/" +
        Uuid().v4().replaceAll('-', '') +
        filePath.substring(filePath.lastIndexOf('.'), filePath.length);
  }

  static String genPhotoName(String filePath) {
    String month = formatDate(DateTime.now(), [yyyy, '-', mm]);
    return "photo/" +
        month +
        "/" +
        Uuid().v4().replaceAll('-', '') +
        filePath.substring(filePath.lastIndexOf('.'), filePath.length);
  }
}

class MyApi {
  static const String HOST = "http://192.168.145.103:80";
  static const String OBS_HOST =
      "https://zaijian.obs.cn-north-4.myhuaweicloud.com";
  static const String DEFAULT_ICON = "/icon/default.jpg";
  static const String DEFAULT_COVER = "/cover/default.jpg";
  static var COMMON_FAIL = {'success': false, 'msg': '请求服务器异常'};

  // 访问服务器用默认的
  static OkHttpClient defaultClient = OkHttpClientBuilder()
      .addInterceptor(NetStateInterceptor())
      .cookieJar(TokenCookieJar())
      //.cache(null) // 后期再考虑加缓存
      .build();

  // 访问obs专用
  static OkHttpClient obsClient = OkHttpClientBuilder()
      .connectionTimeout(Duration(seconds: 20)) // 后期再考虑加缓存
      // 增加进度拦截器
      .addNetworkInterceptor(ProgressRequestInterceptor((HttpUrl url,
          String method, int progressBytes, int totalBytes, bool isDone) {
    //print(url.toString()+"==="+progressBytes.toString()+"/"+totalBytes.toString()+"==="+isDone.toString());
    MyTask.instance.listenProgress(url, progressBytes, totalBytes, isDone);
  })).build();

  static void refreshUserData(rsp) async {
    // 将用户数据存入storage
    SharedPreferences.getInstance().then((stg) {
      dynamic user = rsp[KEY.USER];
      stg.setString(KEY.USER, json.encode(user));
      stg.setString(KEY.USER_ID, user[KEY.USER_ID]);
    });
  }

  static Future<dynamic> callAndRefreshUser(Request request) async {
    try {
      Response rsp = await defaultClient.newCall(request).enqueue();
      if (rsp.isSuccessful()) {
            String data = await rsp.body().string();
            dynamic res = json.decode(data);
            refreshUserData(res);
            return res;
          }
    } catch (e) {
      print(e);
    }
    return COMMON_FAIL;
  }
  static Future<dynamic> call(Request request) async {
    try {
      Response rsp = await MyApi.defaultClient.newCall(request).enqueue();
      if (rsp.isSuccessful()) {
        String data = await rsp.body().string();
        return json.decode(data);
      }
    } catch (e) {
      print(e);
    }
    return COMMON_FAIL;
  }
}

class NetStateInterceptor extends Interceptor {
  @override
  Future<Response> intercept(Chain chain) async {
    var value = await (Connectivity().checkConnectivity());
    if (value == ConnectivityResult.none) {
      EasyLoading.showError("网络异常");
      return ResponseBuilder()
          .request(chain.request())
          .message("网络异常")
          .code(599)
          .build();
    }
    return chain.proceed(chain.request());
  }
}

class TokenCookieJar extends CookieJar {
  @override
  // ignore: missing_return
  Future<void> saveFromResponse(HttpUrl url, List<Cookie> cookies) {
    if (cookies != null) {
      SharedPreferences.getInstance().then((stg) {
        cookies.forEach((cookie) {
          if (cookie.name == KEY.TOKEN) {
            stg.setString(KEY.TOKEN, cookie.value);
          }
        });
      });
    }
  }

  @override
  Future<List<Cookie>> loadForRequest(HttpUrl url) {
    // ignore: missing_return
    return SharedPreferences.getInstance().then((stg) {
      String value = stg.getString(KEY.TOKEN);
      if (value != null) {
        return [Cookie(KEY.TOKEN, value)];
      }
      return [];
    });
  }
}

class UserApi {
  /*用户api*/
  static const String POST_UPDATE_INFO = "/user/updateInfo"; // 跟新用户基本信息
  static const String POST_CHANGE_PHONE = "/user/changePhone"; // 修改绑定手机
  static const String PUT_UPDATE_ICON = "/user/updateIcon"; // 修改头像

  static Future<dynamic> changePhone(String uid, String phone, String code) {
    RequestBody body = RequestBody.textBody(MediaType.parse("application/json"),
        json.encode({'uid': uid, 'phone': phone, 'code': code}));
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_CHANGE_PHONE))
        .post(body)
        .build();
    return MyApi.callAndRefreshUser(request);
  }

  static Future<dynamic> updateInfo(
      String uid, String nickName, int sex, String birthDay) {
    RequestBody body = RequestBody.textBody(
        MediaType.parse("application/json"),
        json.encode({
          'uid': uid,
          'nickName': nickName,
          'sex': sex,
          'birthDay': birthDay
        }));
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_UPDATE_INFO))
        .post(body)
        .build();
    return MyApi.callAndRefreshUser(request);
  }

  static Future<dynamic> updateIcon(String uid, String icon) {
    RequestBody body =
        FormBodyBuilder().add('uid', uid).add('icon', icon).build();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + PUT_UPDATE_ICON))
        .put(body)
        .build();
    return MyApi.callAndRefreshUser(request);
  }
}

class LoginApi {
  static const String POST_LOGIN_PC = '/login/phoneCode';
  static const String POST_SIGNUP = '/login/signup';
  static const String POST_SEND_SMS = '/sms/send';

  static Future<dynamic> login(String phone, String code) {
    RequestBody body = RequestBody.textBody(MediaType.parse("application/json"),
        json.encode({'phone': phone, 'code': code}));
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_LOGIN_PC))
        .post(body)
        .build();
    return MyApi.callAndRefreshUser(request);
  }

  // 注册
  static Future<dynamic> signup(String phone, String code) {
    RequestBody body = RequestBody.textBody(MediaType.parse("application/json"),
        json.encode({'phone': phone, 'code': code}));
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_SIGNUP))
        .post(body)
        .build();
    return MyApi.callAndRefreshUser(request);
  }

  // 注册
  static Future<dynamic> sendSms(String phone) {
    RequestBody body = RequestBody.textBody(
        MediaType.parse("application/json"), json.encode({'phone': phone}));
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_SEND_SMS))
        .post(body)
        .build();
    return MyApi.call(request);
  }
}

class TokenApi {
  static const String POST_TOKEN = "/token/refresh";

  static void refresh() {
    RequestBody body =
        RequestBody.textBody(MediaType.parse("application/json"), '');
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_TOKEN))
        .post(body)
        .build();
    try {
      MyApi.defaultClient.newCall(request).enqueue();
    } catch (e) {
      print(e);
    }
  }
}

class OBSApi {
  static const String POST_UPLOAD_AUTH = "/obs/uploadAuth";

  static Future<bool> uploadFile(String objectId, File file) async {
    FormBody formBody = FormBodyBuilder().add('objectId', objectId).build();
    Request authReq = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_UPLOAD_AUTH))
        .post(formBody)
        .build();

    Response authRsp = await MyApi.defaultClient.newCall(authReq).enqueue();
    if (authRsp.isSuccessful()) {
      RequestBody requestBody =
          RequestBody.fileBody(MediaType.parse("text/plain"), file);
      String rsp = await authRsp.body().string();
      dynamic res = json.decode(rsp);
      Request request = RequestBuilder()
          .url(HttpUrl.parse(res['authUrl']))
          .put(requestBody)
          .build();
      Response obsRsp = await MyApi.obsClient.newCall(request).enqueue();
      return obsRsp.isSuccessful();
    }
    return false;
  }

  static Future<bool> uploadObsBytes(String objectId, List<int> bytes) async {
    FormBody formBody = FormBodyBuilder().add('objectId', objectId).build();
    Request authReq = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + POST_UPLOAD_AUTH))
        .post(formBody)
        .build();
    try {
      Response authRsp = await MyApi.defaultClient.newCall(authReq).enqueue();
      if (authRsp.isSuccessful()) {
            RequestBody requestBody =
                RequestBody.bytesBody(MediaType.parse("text/plain"), bytes);
            String rsp = await authRsp.body().string();
            dynamic res = json.decode(rsp);
            Request request = RequestBuilder()
                .url(HttpUrl.parse(res['authUrl']))
                .put(requestBody)
                .build();
            Response obsRsp = await MyApi.obsClient.newCall(request).enqueue();
            return obsRsp.isSuccessful();
          }
    } catch (e) {
      print(e);
    }
    return false;
  }
}

class MemoryApi {
  static const String PUT_SAVE = "/memory/save";
  static const String DELETE = "/memory/delete";
  static const String DELETE_ITEM = "/memory/deleteItem";
  static const String GET_PAGE_LIST = "/memory/pageList";
  static const String GET_ITEM_UPLOAD_HIS_PAGE_LIST = "/memory/itemUploadHispageList";
  static const String GET_EYEWITNESS_PAGE_LIST = "/memory/eyewitnessPageList";
  static const String DELETE_EYEWITNESS = "/memory/deleteEyewitness";
  static const String PUT_MEMORY_ITEM = "/memory/addMemoryItem";
  static const String PUT_MEMORY_ITEM_STATUS = "/memory/updateMemoryItemStatus";

  // 懒人提交接口
  static Future<dynamic> putJson(String url, dynamic data) {
    RequestBody body = RequestBody.textBody(
        MediaType.parse("application/json"), json.encode(data));
    Request request =
        RequestBuilder().url(HttpUrl.parse(MyApi.HOST + url)).put(body).build();
    return MyApi.call(request);
  }

  static Future<dynamic> delete(String id) {
    RequestBody body = FormBodyBuilder().add('id', id).build();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + DELETE))
        .delete(body)
        .build();
    return MyApi.call(request);
  }

  // 懒人写法
  static Future<dynamic> deleteById(String url, String id) {
    RequestBody body = FormBodyBuilder().add('id', id).build();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + url))
        .delete(body)
        .build();
    return MyApi.call(request);
  }

  static Future<dynamic> pageList(String uid, int curPage, int length) {
    String param = "?uid=" +
        uid +
        "&curPage=" +
        curPage.toString() +
        "&length=" +
        length.toString();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + GET_PAGE_LIST + param))
        .get()
        .build();
    return MyApi.call(request);
  }

  // 懒人get接口
  static Future<dynamic> getList(String url, Map params) {
    String param = '';
    for (int i = 0; i < params.entries.length; i++) {
      MapEntry item = params.entries.elementAt(i);
      param += (i == 0 ? '?' : '&') + item.key + '=' + item.value.toString();
    }
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + url + param))
        .get()
        .build();
    return MyApi.call(request);
  }

  static Future<dynamic> eyewitnessList(String mid, int curPage, int length) {
    String param = "?mid=" +
        mid +
        "&curPage=" +
        curPage.toString() +
        "&length=" +
        length.toString();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + GET_EYEWITNESS_PAGE_LIST + param))
        .get()
        .build();
    return MyApi.call(request);
  }

  static Future<dynamic> deleteEyewitness(String mid, String uid) {
    RequestBody body =
        FormBodyBuilder().add('mid', mid).add('uid', uid).build();
    Request request = RequestBuilder()
        .url(HttpUrl.parse(MyApi.HOST + DELETE_EYEWITNESS))
        .delete(body)
        .build();
    return MyApi.call(request);
  }

  static Future<dynamic> updateMemoryItemStatus(String itemId, int st) {
    RequestBody body = FormBodyBuilder().add('itemId', itemId).add('status', st.toString()).build();
    Request request = RequestBuilder()
            .url(HttpUrl.parse(MyApi.HOST + PUT_MEMORY_ITEM_STATUS))
            .put(body)
            .build();
    return MyApi.call(request);
  }
}
