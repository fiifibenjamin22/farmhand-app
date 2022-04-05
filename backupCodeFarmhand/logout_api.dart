// import 'dart:convert';
// import 'dart:io';

// import 'package:farmhand/constant.dart';
// import 'package:http/io_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future userOutAuthenticate() async {
//   final SharedPreferences prefs = await sharePrefs;
//   final ioc = new HttpClient();
//   ioc.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   final http = new IOClient(ioc);
//   var url = constantURL + "/Users/revoke-token";
//   var headerIN = <String, String>{
//     'accept': '*/*',
//     'Content-Type': 'application/json-patch+json',
//     'Authorization': 'Bearer $jwtToken'
//   };
//   var bodyIN = jsonEncode(<String, String>{'token': refreshToken});
//   var response = await http.post(url, headers: headerIN, body: bodyIN);
//   var decodeBody = response.body;
//   if (response.statusCode == 200) {
//     jwtToken = "";
//     refreshToken = "";
//     prefs.remove("jwtToken");
//     prefs.remove("peopleId");
//     prefs.remove("refreshToken");

//     return [true, json.decode(decodeBody)['message']];
//   } else {
//     print("$jwtToken jwtToken Get");
//     print("$refreshToken refreshToken Get");
//     return [false, "${response.statusCode}"];
//   }
// }
