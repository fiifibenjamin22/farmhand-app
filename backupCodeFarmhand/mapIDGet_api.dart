// import 'dart:convert';
// import 'dart:io';
// import 'package:http/io_client.dart';

// import 'package:farmhand/constant.dart';

// Future mapWorktask(mapId) async {
//   print(mapId);
//   final ioc = new HttpClient();
//   ioc.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   final http = new IOClient(ioc);
//   var url = constantURL + "/Maps/geojson/$mapId";
//   var headerIN = <String, String>{
//     'accept': '*/*',
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $jwtToken',
//     'Charset': 'utf-8'
//   };
//   try {
//     var response = await http.get(
//       url,
//       headers: headerIN,
//     );
//     if (response.statusCode == 200) {
//       // print(json.decode(response.body));
//       return json.encode(json.decode(response.body)[0]);
//     } else {
//       return false;
//     }
//   } catch (e) {
//     print("e");
//   }
// }
