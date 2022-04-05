// import 'dart:convert';
// import 'dart:io';
// import 'package:http/io_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:farmhand/constant.dart';

// // Future mapAllWorktask() async {
// //   // print(mapId);
// //   final ioc = new HttpClient();
// //   ioc.badCertificateCallback =
// //       (X509Certificate cert, String host, int port) => true;
// //   final http = new IOClient(ioc);
// //   var urlworkTasks = constantURL + "/WorkTasks";
// //   var urlgeojson = constantURL + "/Maps/geojson/";
// //   var headerIN = <String, String>{
// //     'accept': '*/*',
// //     'Content-Type': 'application/json',
// //     'Authorization': 'Bearer $jwtToken',
// //     'Charset': 'utf-8'
// //   };
// //   try {
// //     var workTasksResponse = await http.get(
// //       urlworkTasks,
// //       headers: headerIN,
// //     );
// //     List workTasksList = json.decode(workTasksResponse.body);
// //     List workTaskMapId = [];
// //     List geojsonData = [];
// //     List workshopLatlan = [];
// //     var geojsonResponse;
// //     for (var item in workTasksList) {
// //       workTaskMapId.add(item["mapId"]);
// //     }
// //     for (var item in workTaskMapId) {
// //       geojsonResponse = await http.get(
// //         urlgeojson + item.toString(),
// //         headers: headerIN,
// //       );
// //       geojsonData.add(json.decode(geojsonResponse.body)[0]);
// //     }
// //     for (var item in geojsonData) {
// //       var coordinateWorkshop =
// //           item['features'][0]['geometry']['coordinates'][0][0];
// //       // print(coordinateWorkshop);
// //       workshopLatlan.add(coordinateWorkshop);
// //     }
// //     if (workTasksResponse.statusCode == 200 &&
// //         geojsonResponse.statusCode == 200) {
// //       // print(json.decode(response.body));
// //       return [workTaskMapId, workshopLatlan];
// //     } else {
// //       return false;
// //     }
// //   } catch (e) {
// //     print(e);
// //   }
// // }

// Future mapAllWorktask() async {
//   // print(mapId);
//   final ioc = new HttpClient();
//   ioc.badCertificateCallback =
//       (X509Certificate cert, String host, int port) => true;
//   final http = new IOClient(ioc);
//   final SharedPreferences prefs = await sharePrefs;
//   var personID = prefs.getInt('peopleId');
//   var urlOrganTasks = constantURL + "/People/$personID";
//   var urlgeojson = constantURL + "/Maps/geojson/";
//   var headerIN = <String, String>{
//     'accept': '*/*',
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $jwtToken',
//     'Charset': 'utf-8'
//   };
//   try {
//     var workTasksResponse = await http.get(
//       urlOrganTasks,
//       headers: headerIN,
//     );

//     List organisationList =
//         json.decode(workTasksResponse.body)['organisations'];

//     // print(organisationList[0]["maps"][0]["id"]);
//     List organisationMaps = [];
//     List organisationMapsID = [];
//     List geojsonData = [];
//     List workshopLatlan = [];
//     var geojsonResponse;
//     for (var item in organisationList) {
//       organisationMaps.add(item["maps"]);
//     }

//     for (var mapsList in organisationMaps) {
//       for (var item in mapsList) {
//         organisationMapsID.add(item['id']);
//       }
//     }

//     for (var item in organisationMapsID) {
//       geojsonResponse = await http.get(
//         urlgeojson + item.toString(),
//         headers: headerIN,
//       );
//       geojsonData.add(json.decode(geojsonResponse.body)[0]);
//     }
//     for (var item in geojsonData) {
//       var coordinateWorkshop =
//           item['features'][0]['geometry']['coordinates'][0][0];
//       // print(coordinateWorkshop);
//       workshopLatlan.add(coordinateWorkshop);
//     }
//     if (workTasksResponse.statusCode == 200 &&
//         geojsonResponse.statusCode == 200) {
//       // print(workshopLatlan);
//       return [organisationMapsID, workshopLatlan];
//     } else {
//       return false;
//     }
//   } catch (e) {
//     print(e);
//   }
// }
