import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkTasks {
  static dynamic init({@required Dio dio}) async {
    try {
      String workTasksUrl = constantURL + "/worktasks";
      Response workTasksResponse = await dio.get(workTasksUrl);
      print(workTasksUrl + " - SUCCESS");
      // print("Work Tasks Details Response Body :: " +
      //     workTasksResponse.data.toString());

      SharedPreferences _preferences = await SharedPreferences.getInstance();
      // print("IPS 222 :: " + workTasksResponse.data.toString());
      await _preferences.setString(SharedOfflineData().workTasksDetails,
          json.encode(workTasksResponse.data).toString());

      // return (workTasksResponse.data as List)
      //     .map((x) => WorktaskDetails.fromJson(x))
      //     .toList();
      return workTasksResponse.data;
    } catch (e) {
      print('Error in Getting Work Tasks Details : ' + e.toString());
      if (e is DioError && e.response != null) {
        // print("IPS :: " + e.message.toString());
        return Future.error(e.response.data['message']);
      } else {
        return Future.error('Work Task Details : Unexpected Error Occured');
      }
    }
  }
}
