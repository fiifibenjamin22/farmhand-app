// import 'dart:convert';
// import 'dart:io';

// import 'package:farmhand/constant.dart';
// import 'package:http/io_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future userInAuthenticate(String userName, String passWord) async {
//   final SharedPreferences prefs = await sharePrefs;
//   final ioc = new HttpClient();
//   ioc.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   final http = new IOClient(ioc);
//   var url = constantURL + "/Users/authenticate";
//   var headerIN = <String, String>{
//     'accept': '*/*',
//     'Content-Type': 'application/json-patch+json',
//   };
//   var bodyIN =
//       jsonEncode(<String, String>{'username': userName, 'password': passWord});
//   var response = await http.post(url, headers: headerIN, body: bodyIN);
//   var decodeBody = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     jwtToken = await prefs
//         .setString("jwtToken", decodeBody["jwtToken"])
//         .then((bool success) => decodeBody["jwtToken"]);
//     refreshToken = await prefs
//         .setString("refreshToken", decodeBody["refreshToken"])
//         .then((bool success) => decodeBody["refreshToken"]);
//     prefs.setInt("peopleId", decodeBody["personID"]);
//     print("$jwtToken jwtToken Get");
//     print("$refreshToken refreshToken Get");
//     return [true, decodeBody];
//   } else {
//     return [false, decodeBody["message"]];
//   }
// }
