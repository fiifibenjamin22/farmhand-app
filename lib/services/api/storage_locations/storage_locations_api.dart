import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAllStorageLocations {
  static Future<List<StorageLocations>> init({@required Dio dio}) async {
    SharedPreferences _preference = await SharedPreferences.getInstance();
    try {
      String allStorageLocationsUrl = constantURL + "/StorageLocations";
      Response allLocationsResponse = await dio.get(allStorageLocationsUrl);
      print(allStorageLocationsUrl + " - SUCCESS.");
      // print("Storage Locations Response Body :: " +
      //     allLocationsResponse.data.toString());

      await _preference.setString(SharedOfflineData().storageLocations,
          allLocationsResponse.data.toString());
      return (allLocationsResponse.data as List)
          .map((x) => StorageLocations.fromJson(x))
          .toList();
    } catch (e) {
      print('Error in Getting Storage Locations : ' + e.toString());
      if (e is DioError && e.response != null) {
        // print("IPS :: " + e.message.toString());
        return Future.error(e.response.data['message']);
      } else {
        // return Future.error('Storage Locations : Unexpected Error Occured');

        String result =
            _preference.getString(SharedOfflineData().storageLocations);
        // print(result.toString());
        List<StorageLocations> locations;

        if (result != null) {
          if (result.isNotEmpty) {
            var data = json.decode(result);
            locations = (data as List)
                .map((x) => StorageLocations.fromJson(x))
                .toList();
          }
        }

        return locations;
      }
    }
  }
}
