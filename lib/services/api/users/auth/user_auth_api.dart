import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/auth_user_details_model.dart';
import 'package:flutter/cupertino.dart';

class AuthUserWithCredentials {
  static Future<AuthUserDetails> init({
    @required Dio dio,
    @required String userName,
    @required String password,
  }) async {
    try {
      Map<String, String> headerData = {
        'accept': '*/*',
        'Content-Type': 'application/json',
      };
      String uriString = constantURL + SharedOfflineData.authUnencodedPath;
      Response authResponse = await dio.post(
        uriString,
        options: Options(headers: headerData),
        data: jsonEncode(
            <String, String>{'username': userName, 'password': password}),
      );

      // print("Response Body :: " + authResponse.data.toString());

      return AuthUserDetails.fromJson(authResponse.data);
    } catch (e) {
      print('Error in Authentication : ' + e.toString());
      if (e is DioError && e.response != null) {
        print("IPS :: " + e.response.data['message'].toString());
        return Future.error(e.response.data['message']);
      } else {
        return Future.error('unexpected error');
      }
    }
  }
}
