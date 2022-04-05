import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/auth_user_details_model.dart';
import 'package:farmhand/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JWTWorkerInterceptor extends Interceptor {
  final Dio _dio;
  // final

  JWTWorkerInterceptor(this._dio);

  //Check if jwt is expired
  //if expired, then refresh token
  //if refresh token is expired, then logout
  //if refresh token is not expired, then refresh token
  //if jwt is not expired, then continue with call
  //if jwt is refreshed, then continue with call
  @override
  Future onRequest(RequestOptions options) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString("jwtToken");
    if (token != null && token.isNotEmpty) {
      bool hasExpired = JwtDecoder.isExpired(token);
      print("jwt has expired " + hasExpired.toString());
      if (hasExpired) {
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();
        try {
          token = await refreshToken();
        } catch (e) {
          print("token refresh error" + e.toString());
          _dio.interceptors.requestLock.unlock();
          _dio.interceptors.responseLock.unlock();
          await navigatorKey.currentState.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => FormLogin(),
              ),
              (route) => false);
        }
        _dio.interceptors.requestLock.unlock();
        _dio.interceptors.responseLock.unlock();
      }
      options.headers.addAll({'Authorization': "Bearer $token"});
    }
    print(
        'REQUEST[${options.method}] => PATH: ${options.path} => HEADER: ${options.headers} => DATA: ${options.data} => QueryParams: ${options.queryParameters}');
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError error) {
    return super.onError(error);
  }

  static Future<String> refreshToken() async {
    print("Calling Refresh Token");
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    print(
        'REQUEST[GET] => PATH: ${constantURL + SharedOfflineData.refreshTokenUnencodedPath}');
    try {
      String refreshToken = _preferences.getString("refreshToken");
      print("replacing token: " + refreshToken);
      if (refreshToken != null) {
        Map<String, String> body = {"refreshToken": refreshToken};
        Dio dio = new Dio();
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
        Response response = await dio.post(
          constantURL + SharedOfflineData.refreshTokenUnencodedPath,
          data: body,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "x-auth-refresh-token": refreshToken,
            },
          ),
        );

        print("Farmhand Interceptor Refresh Token :: " + response.toString());
        AuthUserDetails refreshTokenModel =
            AuthUserDetails.fromJson(response.data);
        jwtToken = refreshTokenModel.jwtToken;
        String xAuthRefreshToken = refreshTokenModel.refreshToken;
        await _preferences.setString("jwtToken", jwtToken);
        await _preferences.setString("refreshToken", xAuthRefreshToken);

        return jwtToken;
      } else {
        await navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => FormLogin(),
            ),
            (route) => false);
        return Future.error('No refresh token found, login again to continue');
      }
    } catch (e) {
      print("error thrown when calling Refresh Token");
      print(e.toString());
      throw(e);
    }
  }
}
