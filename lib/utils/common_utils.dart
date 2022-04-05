import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences _preferences;

  Future<ConnectivityResult> getInternetStatus() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    return connectivityResult;
  }

  static initPreferences() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  static String getStringFromPreferences(String key) {
    if (_preferences == null) {
      initPreferences();
    }
    return _preferences.getString(key) ?? "";
  }

  static int getIntFromPreferences(String key) {
    if (_preferences == null) {
      initPreferences();
    }
    return _preferences.getInt(key) ?? 0;
  }

  static setStringToPreferences(String key, String value) {
    if (_preferences == null) {
      initPreferences();
    }

    _preferences.setString(key, value);
  }

  static setIntToPreferences(String key, int value) {
    if (_preferences == null) {
      initPreferences();
    }

    _preferences.setInt(key, value);
  }

  static removeFromPreferences(String key) {
    if (_preferences == null) {
      initPreferences();
    }

    _preferences.remove(key);
  }

  static clearSharedPreferences() {
    if (_preferences == null) {
      initPreferences();
    }
    _preferences.clear();
  }

  static printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
