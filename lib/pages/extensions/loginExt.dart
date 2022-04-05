import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/auth_user_details_model.dart';
import 'package:farmhand/pages/login.dart';
import 'package:farmhand/pages/splashLoad/load_screenData.dart';
import 'package:farmhand/utils/api_helper.dart';
import 'package:farmhand/widgets/common_progressIndicator.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

extension LoginExtention on FormLoginState {
  loginUsingCredentials(String userName, String password) async {
    currentFocus.unfocus();
    if (userName.isNotEmpty && password.isNotEmpty) {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        showToast("Please check your Internet Connectivity", context,
            durationIN: 3, gravityIN: Toast.BOTTOM);

        return;
      }
      ProgIndicator(context);
      SharedPreferences _preferences = await SharedPreferences.getInstance();

      try {
        AuthUserDetails userDetails = await ApiHelper.getApiService()
            .authUserWithCredentials(userName, password);
        showToast("Login Successful", context,
            durationIN: 3, gravityIN: Toast.BOTTOM);

        await _preferences.setString(
            SharedOfflineData().jwtToken, userDetails.jwtToken);
        await _preferences.setString(
            SharedOfflineData().refreshToken, userDetails.refreshToken);
        await _preferences.setString(
            SharedOfflineData().expiresUTC, userDetails.expiresUtc.toString());
        await _preferences.setInt(
            SharedOfflineData().peopleId, userDetails.personId);

        Future.delayed(
          Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoadScreenData(),
                // MapImageDownloader(),
              ),
              (route) => false),
        );
      } catch (e) {
        Navigator.pop(context);
        showToast(e.toString(), context,
            durationIN: 3, gravityIN: Toast.BOTTOM);
      }
    } else {
      showToast("Username or Password is empty", context,
          durationIN: 3, gravityIN: Toast.BOTTOM);
    }
  }
}
