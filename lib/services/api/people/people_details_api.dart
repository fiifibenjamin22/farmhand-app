import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeopleDetials {
  static Future<PersonDetails> init({
    @required Dio dio,
    @required int peopleId,
  }) async {
    SharedPreferences _preference = await SharedPreferences.getInstance();
    try {
      String peopleIdUrl = constantURL + "/people/$peopleId";
      Response peopleDetailsResponse = await dio.get(peopleIdUrl);
      print(peopleIdUrl + " - SUCCESS");
      // print("People Details Response Body :: " +
      //     peopleDetailsResponse.data.toString());

      _preference.setString(SharedOfflineData().personDetails,
          json.encode(peopleDetailsResponse.data).toString());
      // String userMap = json.encode(peopleDetailsResponse.data);
      // print("IPS 323232 :: " + userMap.toString());

      return PersonDetails.fromJson(peopleDetailsResponse.data);
    } catch (e) {
      print('Error in Getting People Details : ' + e.toString());
      if (e is DioError && e.response != null) {
        // print("IPS :: " + e.message.toString());
        return Future.error(e.response.data['message']);
      } else {
        String offlineData =
            _preference.getString(SharedOfflineData().personDetails);
        if (offlineData != null && offlineData.isNotEmpty) {
          return PersonDetails.fromJson(json.decode(offlineData));
        } else {
          return Future.error("Something went Wrong");
        }
      }
    }
  }
}
