import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:okhttp_kit/okhttp3/form_body.dart';
import 'package:okhttp_kit/okhttp3/okhttp_client.dart';
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KEY {
  static const String TOKEN = "token";
  static const String USER = "user";
  static const String USER_ID = "id";
  static const String SUCCESS = "success";
  static const String MSG = "msg";
}

class MyApi {
  static const String HOST = "http://192.168.145.103:80";
  static const String OBS_HOST = "https://zaijian.obs.cn-north-4.myhuaweicloud.com";
  static var COMMON_FAIL = {'success': false, 'msg': '请求服务器异常'};
  // 访问服务器用默认的
  static OkHttpClient defaultClient = OkHttpClientBuilder()
      .connectionTimeout(Duration(seconds: 5))
      .cookieJar(TokenCookieJar())
      //.cache(null) // 后期再考虑加缓存
      .build();
  // 访问obs专用
  static OkHttpClient obsClient = OkHttpClientBuilder()
      .connectionTimeout(Duration(seconds: 10)) // 后期再考虑加缓存
      .build();
  static void refreshUserData(rsp) async {
    // 将用户数据存入storage
    SharedPreferences.getInstance().then((stg) {
      dynamic user = rsp[KEY.USER];
      stg.setString(KEY.USER, json.encode(user));
      stg.setString(KEY.USER_ID, user[KEY.USER_ID]);
    });
  }

  static Future<dynamic> callAndRefreshUser(Request request) async {
    Response rsp = await defaultClient.newCall(request).enqueue();
    if (rsp.isSuccessful()) {
      String data = await rsp.body().string();
      dynamic res = json.decode(data);
      refreshUserData(res);
      return res;
    }
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
    return SharedPreferences.getInstance().then((stg) => [Cookie(KEY.TOKEN, stg.get(KEY.TOKEN))]);
  }
}

class UserApi {
  /*用户api*/
  static const String POST_UPDATE_INFO = "/user/updateInfo"; // 跟新用户基本信息
  static const String POST_CHANGE_PHONE = "/user/changePhone"; // 修改绑定手机
  static const String PUT_UPDATE_ICON = "/user/updateIcon"; // 修改头像

  static Future<dynamic> changePhone(
      String uid, String phone, String code) async {
    try {
      RequestBody body = RequestBody.textBody(
          MediaType.parse("application/json"),
          json.encode({'uid': uid, 'phone': phone, 'code': code}));
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + POST_CHANGE_PHONE))
          .post(body)
          .build();
      return await MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  static Future<dynamic> updateInfo(
      String uid, String nickName, int sex, String birthDay) async {
    try {
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
      return await MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  static Future<dynamic> updateIcon(String uid, String icon) async {
    try {
      RequestBody body =
          FormBodyBuilder().add('uid', uid).add('icon', icon).build();
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + PUT_UPDATE_ICON))
          .put(body)
          .build();
      return await MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }
}

class LoginApi {
  static const String POST_LOGIN_PC = '/login/phoneCode';
  static const String POST_SIGNUP = '/login/signup';
  static const String POST_SEND_SMS = '/sms/send';

  static Future<dynamic> login(String phone, String code) async {
    try {
      RequestBody body = RequestBody.textBody(
          MediaType.parse("application/json"),
          json.encode({'phone': phone, 'code': code}));
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + POST_LOGIN_PC))
          .post(body)
          .build();
      return MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  // 注册
  static Future<dynamic> signup(String phone, String code) async {
    try {
      RequestBody body = RequestBody.textBody(
          MediaType.parse("application/json"),
          json.encode({'phone': phone, 'code': code}));
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + POST_SIGNUP))
          .post(body)
          .build();
      return MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  // 注册
  static Future<dynamic> sendSms(String phone) async {
    try {
      RequestBody body = RequestBody.textBody(
          MediaType.parse("application/json"), json.encode({'phone': phone}));
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + POST_SEND_SMS))
          .post(body)
          .build();
      return MyApi.callAndRefreshUser(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
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
    MyApi.defaultClient.newCall(request).enqueue();
  }
}

class OBSApi {
  static const String POST_UPLOAD_AUTH="/obs/uploadAuth";

  static Future<bool> uploadObs(String objectId, File file) async {
    try {
      FormBody formBody = FormBodyBuilder().add('objectId', objectId).build();
      Request authReq = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST+POST_UPLOAD_AUTH))
          .post(formBody)
          .build();

      Response authRsp = await MyApi.defaultClient.newCall(authReq).enqueue();
      if(authRsp.isSuccessful()){
        RequestBody requestBody = RequestBody.fileBody(MediaType.parse("text/plain"), file);
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

  static Future<bool> uploadObsBytes(String objectId, List<int> bytes) async {
    try {
      FormBody formBody = FormBodyBuilder().add('objectId', objectId).build();
      Request authReq = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST+POST_UPLOAD_AUTH))
          .post(formBody)
          .build();

      Response authRsp = await MyApi.defaultClient.newCall(authReq).enqueue();
      if(authRsp.isSuccessful()){
        RequestBody requestBody = RequestBody.bytesBody(MediaType.parse("text/plain"), bytes);
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
  static const String PUT_SAVE= "/memory/save";
  static const String DELETE= "/memory/delete";
  static const String GET_PAGE_LIST = "/memory/pageList";
  static const String GET_EYEWITNESS_PAGE_LIST = "/memory/eyewitnessPageList";
  static const String DELETE_EYEWITNESS = "/memory/deleteEyewitness";

  static Future<dynamic> call(Request request) async {
    Response rsp = await MyApi.defaultClient.newCall(request).enqueue();
    if (rsp.isSuccessful()) {
      String data = await rsp.body().string();
      return json.decode(data);
    }
  }
  static Future<dynamic> save(dynamic data) async {
    try {
      RequestBody body = RequestBody.textBody(
          MediaType.parse("application/json"),
          json.encode(data));
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + PUT_SAVE))
          .put(body)
          .build();
      return call(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  static Future<dynamic> delete(String id) async {
    try {
      RequestBody body = FormBodyBuilder().add('id',id).build();
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + DELETE))
          .delete(body)
          .build();
      return call(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  static Future<dynamic> pageList(String uid, int curPage, int length) async {
    try {
//      RequestBody body = FormBodyBuilder()
//          .add('uid',uid)
//          .add('curPage', curPage.toString())
//          .add('length', length.toString())
//          .build();
      String param = "?uid="+uid+"&curPage="+curPage.toString()+"&length="+length.toString();
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + GET_PAGE_LIST + param))
          .get()
          .build();
      return call(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }

  static Future<dynamic> eyewitnessList(String mid, int curPage, int length) async {
    try {
      String param = "?mid="+mid+"&curPage="+curPage.toString()+"&length="+length.toString();
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + GET_EYEWITNESS_PAGE_LIST + param))
          .get()
          .build();
      return call(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }
  static Future<dynamic> deleteEyewitness(String mid, String uid) async {
    try {
      RequestBody body = FormBodyBuilder().add('mid',mid).add('uid', uid).build();
      Request request = RequestBuilder()
          .url(HttpUrl.parse(MyApi.HOST + DELETE_EYEWITNESS))
          .delete(body)
          .build();
      return call(request);
    } catch (e) {
      print(e);
    }
    return MyApi.COMMON_FAIL;
  }
}
