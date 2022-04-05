import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/putWorkTaskModel.dart';
import 'package:farmhand/pages/dashboard.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class WorkTaskFinish extends StatelessWidget {
  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var workTaskSingleData =
        Provider.of<WorkTaskDataProvider>(context).workTaskSingleData;
    var paddockNames = Provider.of<WorkTaskDataProvider>(context).paddockNames;
    var getString = Provider.of<WorkTaskDataProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        onPressed: () {
          buildShowDialog(context);
          //<------check Completed List Task then get------>
          List getCompletedList = Utils.getStringFromPreferences(
                      '${SharedOfflineData().completedPaddockTaskLocalSave}-${workTaskSingleData.id}')
                  .isNotEmpty
              ? json.decode(Utils.getStringFromPreferences(
                  '${SharedOfflineData().completedPaddockTaskLocalSave}-${workTaskSingleData.id}'))
              : [];
          //<------end------->

          //<------check Local List Task then get------>
          String getLocalListString = Utils.getStringFromPreferences(
              "${SharedOfflineData().paddockTaskLocalSave}-${workTaskSingleData.id}");
          List getLocalList = getLocalListString.isNotEmpty
              ? json.decode(getLocalListString)
              : [];
          //<------end------->

          List<Paddocks> paddocksFinishedData = [];
          for (var junkgetitem in getLocalList) {
            paddocksFinishedData.add(
              Paddocks(
                key: junkgetitem["key"],
                value: Value(
                  latitude: junkgetitem['value']['latitude'],
                  longitude: junkgetitem['value']['latitude'],
                  time: junkgetitem['value']['time'],
                ),
              ),
            );
          }

          PutworkTask allDataGather = PutworkTask(
            applicationCategoryId: workTaskSingleData
                .worktaskapplication.applicationProduct.applicationCategoryId,
            workTaskID: workTaskSingleData.id,
            paddockEventTypeId: 1,
            clearDateTime: DateTime.now().toString(),
            endDateTime: DateTime.now().toString(),
            notes: getString.noteAreaGet,
            workTaskStatusId: (workTaskSingleData.gpsLocations.length ==
                        getLocalList.length + getCompletedList.length) ||
                    getLocalList.length == 0
                ? workStatusDone
                : workStatusInProgress,
            paddocks: paddocksFinishedData,
          );

          allAPIofFarmHand
              .workTasksPutData(workTaskSingleData.id, allDataGather)
              .then((value) {
            if (value[0]) {
              List<Paddocks> completedPaddocksFinishedData = [];
              if (Utils.getStringFromPreferences(
                      '${SharedOfflineData().completedPaddockTaskLocalSave}-${workTaskSingleData.id}')
                  .isNotEmpty) {
                List completedDatalist = json.decode(Utils.getStringFromPreferences(
                    '${SharedOfflineData().completedPaddockTaskLocalSave}-${workTaskSingleData.id}'));
                for (var completedDatalistitem in completedDatalist) {
                  paddocksFinishedData.add(
                    Paddocks(
                      key: completedDatalistitem["key"],
                      value: Value(
                        latitude: completedDatalistitem['value']['latitude'],
                        longitude: completedDatalistitem['value']['latitude'],
                        time: completedDatalistitem['value']['time'],
                      ),
                    ),
                  );
                }
              }
              String junk = json.encode(completedPaddocksFinishedData);
              String junk2 = json.encode(paddocksFinishedData);
              Utils.setStringToPreferences(
                  '${SharedOfflineData().completedPaddockTaskLocalSave}-${workTaskSingleData.id}',
                  junk2);
              Utils.setStringToPreferences(
                  '${SharedOfflineData().paddockTaskLocalSave}-${workTaskSingleData.id}',
                  junk);
              showToast("${value[1]}", context,
                  durationIN: 3, gravityIN: Toast.BOTTOM);
              Future.delayed(
                Duration(seconds: 3),
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormHandDashboard(),
                  ),
                ),
              );
            } else {
              showToast("${value[1]}", context,
                  durationIN: 3, gravityIN: Toast.BOTTOM);
              Navigator.pop(context);
            }
          }).catchError((e) {
            showToast(
              e.toString(),
              context,
              durationIN: 3,
              gravityIN: Toast.BOTTOM,
            );
          });
        },
        child: Text("Finish"),
        style: ElevatedButton.styleFrom(
          primary: Color(0xfff5c43d),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
