import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/pages/MapDownloader/MapImageDownloader.dart';
import 'package:farmhand/pages/dashboard.dart';
import 'package:farmhand/utils/api_helper.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_gagets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension DashboardExtension on FormHandDashboardState {
  Future returnOfflineData(String key) async {
    print("Offline");
    try {
      String valueFromPrefs = Utils.getStringFromPreferences(key);
      var toReturn = jsonDecode(valueFromPrefs);
      return toReturn;
    } catch (e) {
      throw Exception(e);
    }
  }

  loadData() async {
    preferences = await SharedPreferences.getInstance();

    int peopleId = preferences.getInt(SharedOfflineData().peopleId);
    PersonDetails personDetails =
        await ApiHelper.getApiService().peopleDetails(peopleId);
    for (int i = 0; i < personDetails.organisations.length; i++) {
      preferences.setString(personDetails.organisations[i].partyId.toString(),
          personDetails.organisations[i].name);
    }
    connectivityResult = await (Connectivity().checkConnectivity());

    dynamic workTasksList;
    if (connectivityResult == ConnectivityResult.none) {
      print("No Internet in Dashboard");

      workTasksList =
          await returnOfflineData(SharedOfflineData().workTasksDetails);
    } else {
      workTasksList = await ApiHelper.getApiService().workTaskDetails();
    }

    allAPIofFarmHand.mapForAllOrganisation().whenComplete(() {
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(() {
          mapCheckPart();
          String mapIdsNameList =
              preferences.getString(SharedOfflineData().mapidandNameList);
          if (mapIdsNameList != null && mapIdsNameList.isNotEmpty) {
            organisationNewForm = json.decode(mapIdsNameList);
            gettaskLength(workTasksList);
          } else {
            print("organisation New Form is Empty");
          }
        });
      }
    });
  }

  mapCheckPart() async {
//<---------------- new map check area ------------------------>
    String mapIDInString =
        preferences.getString(SharedOfflineData().userMapIDsGot);
    if (mapIDInString != null && mapIDInString.isNotEmpty) {
      List mapIDListgetINproject = json.decode(mapIDInString);
      String oldMapEntryCheck =
          preferences.getString(SharedOfflineData().oldMapEntryCheckListString);
      if (oldMapEntryCheck == null || oldMapEntryCheck.isEmpty) {
        return;
      } else {
        List oldMapEntryCheckList = json.decode(oldMapEntryCheck);
        if (!listEquals(mapIDListgetINproject, oldMapEntryCheckList)) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MapImageDownloader()),
              (route) => false);
        }
      }
    } else {
      print("CANNOT GET NEW MAP DETAILS..!!");
    }

//<---------------- end ----------------------------------------->
  }

  void gettaskLength(data) async {
    organisationNameFormFinal = {};
    List<dynamic> taskSnapB = data;
    taskSnapB.sort((a, b) => a['dueDateTime'].compareTo(b['dueDateTime']));
    for (var i = 0; i < taskSnapB.length; i++) {
      if ((taskSnapB[i]['workTaskStatusId'] != workStatusDone &&
              taskSnapB[i]['workTaskStatusId'] != workStatusCancelled) &&
          flagToCount) {
        taskDataGetInstant.add(taskSnapB[i]);
      }
    }
    //set all the org names for task list to fetch from
    for (var newFormItem in organisationNewForm) {
      organisationNameFormFinal[newFormItem["id"].toString()] =
          newFormItem["name"];
    }
    taskLengthCreated = taskDataGetInstant.length;
    flagToCount = false;
    // ignore: invalid_use_of_protected_member
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit the App'),
              actions: <Widget>[
                CommonButtonIn(
                  childIn: Text('No'),
                  onPressedIn: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                CommonButtonIn(
                  colorIn: Colors.red,
                  childIn: Text('Yes'),
                  onPressedIn: () {
                    exit(0);
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }
}
