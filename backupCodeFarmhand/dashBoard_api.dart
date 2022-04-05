// import 'dart:convert';
// import 'dart:io';
// import 'package:farmhand/constant.dart';
// import 'package:http/io_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future dashWorktask() async {
//   final ioc = new HttpClient();
//   ioc.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   final http = new IOClient(ioc);
//   final SharedPreferences prefs = await sharePrefs;
//   var personID = prefs.getInt('peopleId');
//   var urlA = constantURL + "/People/$personID";
//   var urlB = constantURL + "/WorkTasks";
//   var headerIN = <String, String>{
//     'accept': '*/*',
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $jwtToken'
//   };
//   try {
//     var responseA = await http.get(
//       urlA,
//       headers: headerIN,
//     );
//     var responseB = await http.get(
//       urlB,
//       headers: headerIN,
//     );
//     if (responseB.statusCode == 200 && responseA.statusCode == 200) {
//       // print(response.body);
//       return [json.decode(responseA.body), json.decode(responseB.body)];
//     }
//   } catch (e) {
//     print("e");
//   }
// }
