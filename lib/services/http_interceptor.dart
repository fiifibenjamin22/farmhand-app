import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/pages/login.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class FarmLogInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    final SharedPreferences prefs = await sharePrefs;
    jwtToken = prefs.getString('jwtToken');
    refreshToken = prefs.getString('refreshToken');
    print("----- Request -----");
    try {
      bool jwtExp = JwtDecoder.isExpired(prefs.getString("jwtToken"));
      if (jwtExp) {
        final ioc = new HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final http = new IOClient(ioc);
        var refreshurl = constantURL + "/Users/refresh-token";
        var headerIN = <String, String>{
          'accept': '*/*',
          'Content-Type': 'application/json',
        };
        var bodyIN = jsonEncode(<String, String>{"refreshToken": refreshToken});
        print("request by refreshToken :: $refreshToken");
        var respondDatain =
            await http.post(refreshurl, headers: headerIN, body: bodyIN);

        if (respondDatain.statusCode == 200) {
          var decodeBody = json.decode(respondDatain.body);

          print("Enter to refresh Token");
          await prefs.setInt("peopleId", decodeBody["personID"]);
          await prefs.setString("jwtToken", decodeBody["jwtToken"]);
          await prefs.setString("refreshToken", decodeBody["refreshToken"]);
          jwtToken = decodeBody["jwtToken"];
          refreshToken = decodeBody["refreshToken"];
          data.headers['Content-Type'] = "application/json";
          data.headers['accept'] = '*/*';
          data.headers['Charset'] = 'utf-8';
          data.headers['Authorization'] = "Bearer ${decodeBody["jwtToken"]}";
          if (data.baseUrl == constantURL + "/Users/revoke-token") {
            data.body = jsonEncode(
                <String, String>{'token': decodeBody["refreshToken"]});
          }
          print("Base URL :: " + data.baseUrl);
          print("Data Header :: " + data.headers.toString());
          return data;
        } else {
          prefs.remove("jwtToken");
          prefs.remove("refreshToken");

          await navigatorKey.currentState.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => FormLogin(),
              ),
              (route) => false);
          return null;
        }
      } else {
        print("Enter to normal Token");

        data.headers['Content-Type'] = "application/json";
        data.headers['accept'] = '*/*';
        data.headers['Charset'] = 'utf-8';
        data.headers['Authorization'] = "Bearer $jwtToken";
        print(data.headers);
        print(data.baseUrl);
        return data;
      }
    } on SocketException catch (_) {
      return data;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print("----- Response -----");
    print(data.url);

    print(data.statusCode);
    return data;
  }
}

// class ExpiredTokenRetryPolicy extends RetryPolicy {
//   Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
//     if (response.statusCode == 412) {
//       return true;
//     }
//     return false;
//   }
// }

class AllAPIofFarmHand {
  HttpClientWithInterceptor clientWithInterceptor;
  AllAPIofFarmHand(this.clientWithInterceptor);

//<--below work under clientwithInterceptor-->

  Future returnOfflineData(String key) async {
    print("Offline");
    try {
      String storageLocations = Utils.getStringFromPreferences(key);
      var toReturn = jsonDecode(storageLocations);
      return toReturn;
    }
    // on FormatException catch (_) {
    // navigatorKey.currentState.pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => NoInternetPage(),
    //     ),
    //     (route) => false);
    //   return null;
    // }
    catch (e) {
      throw Exception(e);
    }
  }

  Future dashWorktaskA() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in DashworkTaskA");

      return await returnOfflineData(SharedOfflineData().personDetails);
    }

    var personID = _preferences.getInt(SharedOfflineData().peopleId);
    var urlA = constantURL + "/People/$personID";

    try {
      var responseA = await clientWithInterceptor.get(urlA);
      // print("HTTP Interceptor Response :: " + responseA.body.toString());
      if (responseA != null) {
        if (responseA.statusCode == 200) {
          String personDetails = responseA.body;

          Utils.setStringToPreferences(
              SharedOfflineData().personDetails, personDetails);

          // Processing Organisation Details to store Organisation Name based on Organisation ID
          PersonDetails details =
              PersonDetails.fromJson(jsonDecode(responseA.body));
          for (int i = 0; i < details.organisations.length; i++) {
            Utils.setStringToPreferences(
                details.organisations[i].partyId.toString(),
                details.organisations[i].name);
          }
          // print("dashbordA person data save by key :: ${SharedOfflineData().personDetails}");
          return responseA.body;
        } else {
          print(
              "responseA Response Code :: " + responseA.statusCode.toString());
        }
      } else {
        print("responseA is NULL..!!");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> storageFarm() async {
    connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet");
      String result =
          Utils.getStringFromPreferences(SharedOfflineData().storageLocations);
      List<dynamic> locations = [];
      if (result != null) {
        if (result.isNotEmpty) {
          locations = (jsonDecode(result));
        }
      }

      return locations;
    }

    var urlA = constantURL + "/StorageLocations";

    try {
      var responseA = await clientWithInterceptor.get(urlA);

      if (responseA.statusCode == 200) {
        List<dynamic> locations = (jsonDecode(responseA.body));
        String storageLocations = jsonEncode(locations);

        Utils.setStringToPreferences(
            SharedOfflineData().storageLocations, storageLocations);

        return locations;
      }

      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future workTasksSingleData(worktaskID) async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in workTasksSingleData");

      return null;
    }
    var urlA = constantURL + "/WorkTasks/$worktaskID";

    try {
      // print("$jwtToken tryin DashA");
      var responseA = await clientWithInterceptor.get(urlA);

      // print("workTaskSingleData :: " + responseA.body);
      if (responseA.statusCode == 200) {
        SingleWorkTask data =
            SingleWorkTask.fromJson(jsonDecode(responseA.body));

        return data;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future workTasksPutData(worktaskID, worktaskPutbody) async {
    var urlA = constantURL + "/WorkTasks/$worktaskID";

    var bodyIN = jsonEncode(worktaskPutbody);
    try {
      final responseA =
          await clientWithInterceptor.put(Uri.parse(urlA), body: bodyIN);

      // print("workTasksPutData :: " + responseA.body);
      if (responseA.statusCode == 200) {
        return [true, "Task submitted successful"];
      }
      return [false, responseA.statusCode];
    } on SocketException catch (_) {
      String offlineStoreCompletedPaddockTask = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreCompletedPaddockTask}");
      List offlineStoreCompletedPaddockTaskList =
          offlineStoreCompletedPaddockTask.isNotEmpty
              ? json.decode(offlineStoreCompletedPaddockTask)
              : [];
      Map<String, dynamic> taskSet = {
        "worktaskidgot": worktaskID,
        "worktaskcomplete": worktaskPutbody
      };
      offlineStoreCompletedPaddockTaskList.add(taskSet);
      String encodeofflineStoreCompletedPaddockTaskList =
          json.encode(offlineStoreCompletedPaddockTaskList);
      Utils.setStringToPreferences(
          SharedOfflineData().offlineStoreCompletedPaddockTask,
          encodeofflineStoreCompletedPaddockTaskList);
      // print(offlineStoreCompletedPaddockTaskList.length);
      return [false, "Data saved local due to no internet connection"];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future postStorageLocationItemLevel(var body) async {
    String postUrl =
        constantURL + "/StorageLocations/PostStorageLocationItemLevel";

    var headers = <String, String>{
      'Authorization': 'Bearer $jwtToken',
    };

    // print("Body :: " + body);
    try {
      var response = await clientWithInterceptor.post(
        postUrl,
        headers: headers,
        body: body,
      );
      // print("Storage Location Item Level Response Code :: " +
      //     response.statusCode.toString());

      if (response.statusCode == 201) {
        Utils.removeFromPreferences(SharedOfflineData().storageLocationContent);
      }
    } on SocketException catch (_) {
      String offlineStoreStorageLocationString = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreStorageLocation}");
      List offlineStoreStorageLocationList =
          offlineStoreStorageLocationString.isNotEmpty
              ? json.decode(offlineStoreStorageLocationString)
              : [];
      offlineStoreStorageLocationList.add(body);
      String encodeofflineStoreStorageLocationList =
          json.encode(offlineStoreStorageLocationList);
      Utils.setStringToPreferences(
          SharedOfflineData().offlineStoreStorageLocation,
          encodeofflineStoreStorageLocationList);
      print(
          "SocketException encodeofflineStoreStorageLocationList : $encodeofflineStoreStorageLocationList");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future paddocksGrazedAPI(grazedPostbody) async {
    var urlA = constantURL + "/Paddocks/PostPaddockEvent";

    var bodyIN = jsonEncode(grazedPostbody);
    try {
      var responseA = await clientWithInterceptor.post(urlA, body: bodyIN);

      print("grazedPost data :: " + responseA.body);
      if (responseA.statusCode == 200) {
        return [true, "Grazed Successful"];
      }
      return [false, "Grazed Failed"];
    } on SocketException catch (_) {
      String offlineStoreSetAsGrazedString = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreSetAsGrazed}");
      List offlineStoreSetAsGrazedList =
          offlineStoreSetAsGrazedString.isNotEmpty
              ? json.decode(offlineStoreSetAsGrazedString)
              : [];
      offlineStoreSetAsGrazedList.add(grazedPostbody);
      String encodeofflineStoreSetAsGrazedList =
          json.encode(offlineStoreSetAsGrazedList);
      Utils.setStringToPreferences(SharedOfflineData().offlineStoreSetAsGrazed,
          encodeofflineStoreSetAsGrazedList);
      print(encodeofflineStoreSetAsGrazedList);
      return [false, "Grazed saved local due to no internet connection"];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future userOutAuthenticate() async {
    final SharedPreferences prefs = await sharePrefs;

    var url = constantURL + "/Users/revoke-token";

    var bodyIN = jsonEncode(<String, String>{'token': refreshToken});

    try {
      var response = await clientWithInterceptor.post(url, body: bodyIN);

      var decodeBody = response.body;

      if (response.statusCode == 200) {
        jwtToken = "";
        refreshToken = "";
        prefs.clear();
        return [true, json.decode(decodeBody)['message']];
      } else {
        print("$jwtToken jwtToken Getout with ${response.statusCode}");
        print("$refreshToken refreshToken Getout with ${response.statusCode}");
        return [false, "${response.statusCode}"];
      }
    } on SocketException {
      jwtToken = "";
      refreshToken = "";
      prefs.clear();
      return [true, "Logout Successful"];
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }

//<--end-->

//<--below work under http request-->

  Future dashWorktaskB() async {
    SharedPreferences _preference = await SharedPreferences.getInstance();
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in DashworkTaskB");

      return await returnOfflineData(SharedOfflineData().workTasksDetails);
    }

    jwtToken = _preference.getString(SharedOfflineData().jwtToken);
    refreshToken = _preference.getString(SharedOfflineData().refreshToken);
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    var urlB = constantURL + "/WorkTasks";
    var headerIN = <String, String>{'Authorization': 'Bearer $jwtToken'};
    try {
      // print("$jwtToken tryin DashB");
      var responseB = await http.get(
        urlB,
        headers: headerIN,
      );
      if (responseB != null) {
        if (responseB.statusCode == 200) {
          bool storeTaskDetails = await _preference.setString(
              SharedOfflineData().workTasksDetails, responseB.body);
          print("storeTaskDetails :: " + storeTaskDetails.toString());

          return json.decode(responseB.body);
        } else {
          print("responseB Status Code :: " + responseB.statusCode.toString());
        }
      } else {
        print("responseB value is NULL..!!");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future mapWorktask(mapId) async {
    print(
        "mapID passed in api is $mapId-${SharedOfflineData().geojsonMapData}");
    connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in mapWorktask");

      return Utils.getStringFromPreferences(
          "$mapId-${SharedOfflineData().geojsonMapData}");
    }
    // final ioc = new HttpClient();
    // ioc.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    // final http = new IOClient(ioc);
    var url = constantURL + "/Maps/geojson/$mapId";
    var headerIN = <String, String>{
      'Authorization': 'Bearer $jwtToken',
    };
    print(url.toString());
    print(headerIN.toString());
    try {
      var response = await clientWithInterceptor.get(
        url,
        headers: headerIN,
      );
      // print("Response :: " + response.body.toString());
      if (response.statusCode == 200) {
        // print(json.decode(response.body));
        return json.encode(json.decode(response.body)[0]);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future mapAllWorktask() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    var personID = _preferences.getInt(SharedOfflineData().peopleId);
    var urlOrganTasks = constantURL + "/People/$personID";
    var urlgeojson = constantURL + "/Maps/geojson/";
    var headerIN = <String, String>{
      'Authorization': 'Bearer $jwtToken',
    };
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in mapAllWorktask");

      var workTasksResponse =
          await returnOfflineData(SharedOfflineData().personDetails);
      List organisationList = workTasksResponse['organisations'];

      List organisationMaps = [];
      List organisationMapsID = [];
      List geojsonData = [];
      List workshopLatlan = [];
      var geojsonResponse;
      for (var item in organisationList) {
        organisationMaps.add(item["maps"]);
      }

      for (var mapsList in organisationMaps) {
        for (var item in mapsList) {
          organisationMapsID.add(item['id']);
        }
      }

      for (var item in organisationMapsID) {
        print("get the mapid111 :: $item");
        geojsonResponse = await returnOfflineData(
            "$item-${SharedOfflineData().geojsonMapData}");
        geojsonData.add(geojsonResponse);
      }
      for (var item in geojsonData) {
        var coordinateWorkshop =
            item['features'][0]['geometry']['coordinates'][0][0];
        // print(coordinateWorkshop);
        workshopLatlan.add(coordinateWorkshop);
      }
      if (workTasksResponse != null && geojsonResponse != null) {
        return [organisationMapsID, workshopLatlan];
      } else {
        return false;
      }
    }
    {
      try {
        var workTasksResponse = await http.get(
          urlOrganTasks,
          headers: headerIN,
        );

        List organisationList =
            json.decode(workTasksResponse.body)['organisations'];

        List organisationMaps = [];
        List organisationMapsID = [];
        List geojsonData = [];
        List workshopLatlan = [];
        var geojsonResponse;
        for (var item in organisationList) {
          organisationMaps.add(item["maps"]);
        }

        for (var mapsList in organisationMaps) {
          for (var item in mapsList) {
            organisationMapsID.add(item['id']);
          }
        }

        for (var item in organisationMapsID) {
          print("get the mapid222 :: $item");
          geojsonResponse = await http.get(
            urlgeojson + item.toString(),
            headers: headerIN,
          );
          if (geojsonResponse.statusCode == 200) {
            geojsonData.add(json.decode(geojsonResponse.body)[0]);
          }
        }
        for (var item in geojsonData) {
          var coordinateWorkshop =
              item['features'][0]['geometry']['coordinates'][0][0];
          // print(coordinateWorkshop);
          workshopLatlan.add(coordinateWorkshop);
        }
        if (workTasksResponse.statusCode == 200 &&
            geojsonResponse.statusCode == 200) {
          // print(workshopLatlan);
          return [organisationMapsID, workshopLatlan];
        } else {
          return false;
        }
      } catch (e) {
        print("catchError :: $e");
        throw Exception(e);
      }
    }
  }

  Future<List> getAllOrganisationsList() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    final httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final ioClient = new IOClient(httpClient);

    var personID = _preferences.getInt(SharedOfflineData().peopleId);
    var peopleOrganisationsUrl = constantURL + "/People/$personID";

    var headerIN = <String, String>{
      'Authorization': 'Bearer $jwtToken',
    };
    List organisationList;
    connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in List Location Screen");
      var junkdata = await returnOfflineData(SharedOfflineData().personDetails);

      return junkdata['organisations'];
    }
    try {
      var personDetailsResponse = await ioClient.get(
        peopleOrganisationsUrl,
        headers: headerIN,
      );
      if (personDetailsResponse.body.isNotEmpty) {
        organisationList =
            json.decode(personDetailsResponse.body)['organisations'];
      }

      // print(organisationList.toString());
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }

    return organisationList;
  }

  Future mapForAllOrganisation() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print(" No Internet in mapForAllOrganisation");

      return await returnOfflineData(SharedOfflineData().mapidandNameList);
    }

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final SharedPreferences _preferences = await sharePrefs;
    var personID = _preferences.getInt(SharedOfflineData().peopleId);
    var urlOrganTasks = constantURL + "/People/$personID";
    var urlgeojson = constantURL + "/Maps/geojson/";
    var headerIN = <String, String>{
      'Authorization': 'Bearer $jwtToken',
    };
    try {
      var personDetailsResponse = await http.get(
        urlOrganTasks,
        headers: headerIN,
      );
      List organisationList = [];
      try {
        if (personDetailsResponse.body.isNotEmpty) {
          organisationList =
              json.decode(personDetailsResponse.body)['organisations'];
        }
      } catch (e) {
        print("Exception at JSON Decode 111 :: " + e.toString());
      }

      List organisationMaps = [];
      List userMapIDsGet = [];
      List organisationMapsIDandName = [];
      List organisationMapsID = [];
      List geojsonData = [];
      List geojsonDifferData = [];
      List worktaskDetailsdata = [];
      try {
        String taskDetails = Utils.getStringFromPreferences(
            SharedOfflineData().workTasksDetails);
        if (taskDetails.isNotEmpty) {
          // print("TASK DETAILS :: " + taskDetails);
          worktaskDetailsdata = json.decode(taskDetails);
          //worktaskDetailsdata = taskDetails;
        }
      } catch (e) {
        print("Exception at JSON Decode 222 :: " + e.toString());
      }
      List worktaskDifferMapID = [];
      var geojsonDifferResponse;
      var geojsonResponse;
      for (var item in organisationList) {
        organisationMaps.add(item["maps"]);
      }

      for (var mapsList in organisationMaps) {
        for (var item in mapsList) {
          organisationMapsID.add(item['id']);
          organisationMapsIDandName.add({
            "id": item['id'],
            "name": item['name'],
            "organisationID": item['organisationID']
          });
        }
      }
      List dummyDataGet = [];
      for (var worktaskDetailsdataitem in worktaskDetailsdata) {
        if (!organisationMapsID.contains(worktaskDetailsdataitem['mapId'])) {
          dummyDataGet.add(worktaskDetailsdataitem['mapId']);
        }
      }
      worktaskDifferMapID = dummyDataGet.toSet().toList();
      for (var item in organisationMapsIDandName) {
        geojsonResponse = await http.get(
          urlgeojson + item['id'].toString(),
          headers: headerIN,
        );

        try {
          if (geojsonResponse.body.isNotEmpty) {
            geojsonData.add(json.decode(geojsonResponse.body)[0]);
          }
        } catch (e) {
          print("Exception at JSON Decode 333 :: " + e.toString());
        }
      }

      if (worktaskDifferMapID.isNotEmpty) {
        for (var workMapIDitem in worktaskDifferMapID) {
          geojsonDifferResponse = await http.get(
            urlgeojson + workMapIDitem.toString(),
            headers: headerIN,
          );

          try {
            if (geojsonDifferResponse.body.isNotEmpty) {
              geojsonDifferData.add(json.decode(geojsonDifferResponse.body)[0]);
            }
          } catch (e) {
            print("Exception at JSON Decode 444 :: " + e.toString());
          }
        }

        if (geojsonDifferResponse.statusCode == 200) {
          for (int i = 0; i < worktaskDifferMapID.length; i++) {
            String geojsonDiffertoString = json.encode(geojsonDifferData[i]);
            userMapIDsGet.add(worktaskDifferMapID[i]);
            // print("mapidList koko $worktaskDifferMapID");
            await _preferences.setString(
                "${worktaskDifferMapID[i].toString()}-${SharedOfflineData().geojsonMapData}",
                geojsonDiffertoString);
            // print(
            //     "geojsonDifferData save in Preference by key :: ${worktaskDifferMapID[i].toString()}-${SharedOfflineData().geojsonMapData}");
          }
        }
      }

      print("statusCode :: " + personDetailsResponse.statusCode.toString());

      if (personDetailsResponse.statusCode == 200 &&
          geojsonResponse.statusCode == 200) {
        try {
          for (var i = 0; i < organisationMapsIDandName.length; i++) {
            String geojsontoString = json.encode(geojsonData[i]);
            userMapIDsGet.add(organisationMapsIDandName[i]['id']);
            await _preferences.setString(
                "${organisationMapsIDandName[i]['id'].toString()}-${SharedOfflineData().geojsonMapData}",
                geojsontoString);
            print(
                "geojsonData save in Preference by key :: ${organisationMapsIDandName[i]['id'].toString()}-${SharedOfflineData().geojsonMapData}");
          }
          print(userMapIDsGet.length);
          String makeListIDandNameString =
              json.encode(organisationMapsIDandName);
          await _preferences.setString(
              SharedOfflineData().mapidandNameList, makeListIDandNameString);
          print(
              "mapidandNameList save in Preference by key :: ${SharedOfflineData().mapidandNameList}");
          String makeListIDString = json.encode(organisationMapsID);
          await _preferences.setString(
              SharedOfflineData().mapidList, makeListIDString);
          print(
              "mapidList save in Preference by key :: ${SharedOfflineData().mapidList}");
          String userMapIDsGetStored = json.encode(userMapIDsGet);
          await _preferences.setString(
              SharedOfflineData().userMapIDsGot, userMapIDsGetStored);
          print(
              'over all userMapIDsGot save in Preference by key :: ${SharedOfflineData().userMapIDsGot}');
          print("userMapIDsGetStored :: " + userMapIDsGetStored);
        } catch (e) {
          print("Something went Wrong when reading Geo json response");
          print(e);
          return false;
        }
        return true;
      } else {
        print("ERROR with call to ${personDetailsResponse.request.url } (response code): ${personDetailsResponse.statusCode.toString()}");
        return false;
      }
    } catch (e) {
      print("ERROR with Authentication call:");
      print(e);
      throw Exception(e);
    }
  }
}
