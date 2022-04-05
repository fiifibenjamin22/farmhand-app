import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart';
import '../constant.dart';

Future userInAuthenticate(String userName, String passWord) async {
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  final ioc = new HttpClient();
  ioc.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  final http = new IOClient(ioc);
  var url = constantURL + "/Users/authenticate";
  var headerIN = <String, String>{
    'accept': '*/*',
    'Content-Type': 'application/json',
  };
  var bodyIN =
      jsonEncode(<String, String>{'username': userName, 'password': passWord});
  connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return [false, "No Internet Connection"];
  } else {
    try {
      var response = await http.post(url, headers: headerIN, body: bodyIN);
      var decodeBody = jsonDecode(response.body);
      print("Login Response :: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        jwtToken = await _preferences
            .setString(SharedOfflineData().jwtToken, decodeBody["jwtToken"])
            .then((bool success) => decodeBody["jwtToken"]);
        refreshToken = await _preferences
            .setString("refreshToken", decodeBody["refreshToken"])
            .then((bool success) => decodeBody["refreshToken"]);
        bool expiresUTCStatus = await _preferences.setString(
            SharedOfflineData().expiresUTC, decodeBody['expiresUTC']);
        bool peopleIdStatus = await _preferences.setInt(
            SharedOfflineData().peopleId, decodeBody["personID"]);
        // print("$jwtToken jwtToken Get");
        print("Store People ID :: $peopleIdStatus " +
            decodeBody["personID"].toString());
        print("Store expires UTC :: $expiresUTCStatus ");
        return [true, decodeBody];
      } else {
        return [false, "Either Username or Password is incorrect"];
      }
    } on SocketException {
      return [false, "No Internet Connection"];
    } catch (e) {
      print(e);
    }
  }
}
