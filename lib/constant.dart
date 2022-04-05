import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/pages/dashboard.dart';
import 'package:farmhand/pages/mapView/farms_list_locations_screen.dart';
import 'package:farmhand/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/http_interceptor.dart';

final double heightin = SizeConfig.heightMultiplier;
final double widthin = SizeConfig.widthMultiplier;
final double textsizein = SizeConfig.textMultiplier;
final double imagein = SizeConfig.imageSizeMultiplier;
final production = "https://farmhand.csfarmsolutions.com.au/api";
final uat = "https://farmhand-uat.csfarmsolutions.com.au/api";
final demo = "https://farmhand-demo.csfarmsolutions.com.au/api";
final constantURL = uat;
bool internetCheck = true;
bool expiryCheck = true;
String jwtToken;
ConnectivityResult connectivityResult;
String refreshToken;
List priorityIDstatus = ['Urgent', 'High', 'Medium', 'Low'];
List priorityColors = [Colors.red, Colors.orange, Colors.yellow, Colors.blue];
List workTaskStatus = [
  'Assigned',
  'In Progress',
  'On Hold',
  'Done',
  'Cancelled'
];

final int workStatusAssigned = 1;
final int workStatusInProgress = 2;
final int workStatusOnHold = 3;
final int workStatusDone = 4;
final int workStatusCancelled = 5;

final Future<SharedPreferences> sharePrefs = SharedPreferences.getInstance();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
AllAPIofFarmHand allAPIofFarmHand = AllAPIofFarmHand(
  HttpClientWithInterceptor.build(
    badCertificateCallback: (X509Certificate cert, String host, int port) =>
        true,
    interceptors: [FarmLogInterceptor()],
    // retryPolicy: ExpiredTokenRetryPolicy(),
  ),
);

class SharedOfflineData {
  String jwtToken = "jwtToken";
  String refreshToken = "refreshToken";
  String expiresUTC = "expiresUTC";

  // String workTaskSingleData = "workTaskSingleData";
  String workTasksDetails = "workTasksDetails";
  String personDetails = "personDetails";
  String peopleId = "peopleId";
  String workTaskImageFileLocal = "workTaskImageFileLocal";
  String workTaskImageFileUploaded = "workTaskImageFileUploaded";

  String mapidList = "mapidList";
  String mapidandNameList = "mapidandNameList";
  String geojsonMapData = "geojsonMapData";
  String userMapIDsGot = "userMapIDsGot";
  String oldMapEntryCheckListString = "oldMapEntryCheckListString";

  String storageLocationContent = "storageLocationContent";
  String storageLocations = "storageLocations";
  String paddockTaskLocalSave = "paddockTaskLocalSave";
  String completedPaddockTaskLocalSave = "completedPaddockTaskLocalSave";
  String offlineStoreCompletedPaddockTask = "offlineStoreCompletedPaddockTask";
  String offlineStoreSetAsGrazed = "offlineStoreSetAsGrazed";
  String offlineStoreStorageLocation = "offlineStoreStorageLocation";

  static final String authUnencodedPath = "/users/authenticate";
  static final String refreshTokenUnencodedPath = '/users/refresh-token';
}

String imagePathINTO;

List dashA = [
  {"name": "FARMS", "point": "16", "image": "assets/farm_dash.svg"},
  // {"name": "STORAGE", "point": "1", "image": "assets/storage_dash.svg"}
];

List dashB = [
  {"taskName": "TASK NAME ONE", "taskimg": "assets/dashB1.svg"},
  {"taskName": "TASK NAME TWO", "taskimg": "assets/dashB2.svg"},
  {"taskName": "TASK NAME THREE", "taskimg": "assets/dashB3.svg"}
];
int taskLength = 0;
// dictionary of org names with ids
Map<String, String> organisationNameFormFinal = new Map();

List dashAA = [
  {
    "name": "DASHBOARD",
    "image": "assets/dash_dash.svg",
    "nav": FormHandDashboard(),
  },
  {
    "name": "FARMS",
    "image": "assets/farm_dash.svg",
    // "nav": MapViewAllWorkShop(
    //   leadingBack: true,
    // ),
    "nav": ListPaddockLocations(
      includeStorageLocations: false,
    ),
  },
  // This is being kept for future development of storage locations code
  // {
  // "name": "MAPS",
  // "image": "assets/map_dash.svg",
  // "nav": MapViewAllWorkShop(
  //   getStorageLocation: true,
  //   leadingBack: true,
  // ),
  // "nav": ListPaddockLocations(
  //   includeStorageLocations: true,
  // ),
  // },
  // {
  //   "name": "STORAGE",
  //   "image": "assets/storage_dash.svg",
  //   "nav": StorageLocationsScreen(
  //     initalIndex: 0,
  //   ), //StorageIN(),
  // }
];
