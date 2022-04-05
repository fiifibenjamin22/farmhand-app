import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/putWorkTaskModel.dart';
import 'package:farmhand/pages/taskPage/Cards/SingleCardPaddockB.dart';
import 'package:farmhand/pages/taskPage/taskpaddockB.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_showConfirmAlert.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_broadcast_receiver/flutter_broadcast_receiver.dart';

extension SingleCardPaddockBExt on SingleCardPaddockBState {
  checkTaskComplete(paddockDoneTaskget) async {
    List getList = Utils.getStringFromPreferences(
                '${SharedOfflineData().paddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}')
            .isNotEmpty
        ? json.decode(Utils.getStringFromPreferences(
            '${SharedOfflineData().paddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}'))
        : [];
    List getCompletedList = Utils.getStringFromPreferences(
                '${SharedOfflineData().completedPaddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}')
            .isNotEmpty
        ? json.decode(Utils.getStringFromPreferences(
            '${SharedOfflineData().completedPaddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}'))
        : [];
    if (isReRenderingAllowed) {
      for (var i = 0; i < widget.paddockName.length; i++) {
        for (var getListitem in getList) {
          if (widget.paddockName[i]['paddockId'].toString() ==
              getListitem['key'].toString()) {
            widget.commonColors[i] = Colors.grey;
            widget.buttonCheckString[i] = "Task \nCompleted";
          } else {
            redGreenliveCheck(i);
          }
        }
        for (var getCompletedListitem in getCompletedList) {
          if (widget.paddockName[i]['paddockId'].toString() ==
              getCompletedListitem['key'].toString()) {
            widget.commonColors[i] = Colors.grey;
            widget.buttonCheckString[i] = "Task \nCompleted";
          } else {
            redGreenliveCheck(i);
          }
        }
      }
    }
  }

  redGreenliveCheck(i) {
    if (widget.commonColors[i] != Colors.grey &&
        widget.commonColors[i] != Colors.blue) {
      List<LatLng> listOfLatLangs = widget.polygonDataPoint.toSet().toList();
      bool checkLocationPaddock =
          geodesy.isGeoPointInPolygon(currentpoint, listOfLatLangs);
      if (checkLocationPaddock) {
        widget.commonColors[i] = Colors.green;
      } else {
        widget.commonColors[i] = Colors.red;
      }
    }
  }

  navigateFromCard(WorkTaskDataProvider paddockDoneTaskget) {
    String junk = Utils.getStringFromPreferences(
        "${SharedOfflineData().paddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}");
    List<Paddocks> paddocksFinishedData = [];
    List junkget = junk.isEmpty ? [] : json.decode(junk);
    for (var junkgetitem in junkget) {
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
    paddockLocalDoneTask = paddocksFinishedData;
    if (
        // buttonColor
        widget.commonColors[widget.paddockIndex] == Colors.red) {
      showConfirmationDialog(context,
          "Your location does not match with Paddock Location. Are you sure you want to complete this task?",
          () {
        // ignore: invalid_use_of_protected_member
        setState(() {
          Navigator.of(context).pop();

          widget.buttonCheckString[widget.paddockIndex] = "Task \nCompleted";
          widget.commonColors[widget.paddockIndex] = Colors.grey;

          paddockLocalDoneTask.add(
            Paddocks(
              key: widget.paddockName[widget.paddockIndex]["paddockId"],
              value: Value(
                latitude: currentpoint.latitude,
                longitude: currentpoint.latitude,
                time: DateTime.now().toString(),
              ),
            ),
          );
          String junk = json.encode(paddockLocalDoneTask);
          Utils.setStringToPreferences(
              "${SharedOfflineData().paddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}",
              junk);
        });

        /// closing modal Event
        BroadcastReceiver().publish<String>('POP_CLOSE_EVENT', arguments: '');
      }, false);
    } else if (widget.commonColors[widget.paddockIndex] == Colors.green) {
      widget.commonColors[widget.paddockIndex] = Colors.grey;
      widget.buttonCheckString[widget.paddockIndex] = "Task \nCompleted";
      paddockLocalDoneTask.add(
        Paddocks(
          key: widget.paddockName[widget.paddockIndex]["paddockId"],
          value: Value(
            latitude: currentpoint.latitude,
            longitude: currentpoint.latitude,
            time: DateTime.now().toString(),
          ),
        ),
      );
      String junk = json.encode(paddockLocalDoneTask);
      Utils.setStringToPreferences(
          "${SharedOfflineData().paddockTaskLocalSave}-${paddockDoneTaskget.worktaskID}",
          junk);
    }
  }
}
