import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaijian/com/yestoday/common/DioFactory.dart';
import 'package:zaijian/com/yestoday/common/BaseConfig.dart';

class TokenApi {
  static const String POST_TOKEN = "/token/refresh";

  static void refresh() {
    DioFactory.tokenDio().then((dio) {
      dio.post(BaseConfig.HOST + POST_TOKEN).then((rsp) => {
            if (rsp.statusCode == HttpStatus.ok)
              {
                SharedPreferences.getInstance().then((stg) {
                  if (rsp.data[MyKeys.TOKEN] != null) {
                    stg.setString(MyKeys.TOKEN, rsp.data[MyKeys.TOKEN]);
                  }
                })
              }
          });
    });
  }
}
