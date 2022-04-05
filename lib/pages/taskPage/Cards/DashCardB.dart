import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/pages/taskPage/Cards/SingleDashCardB.dart';
import 'package:farmhand/pages/taskPage/taskPage.dart';
import 'package:flutter/material.dart';

class DashCardB extends StatelessWidget {
  final List<dynamic> taskDataGet;
  DashCardB({this.taskDataGet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(taskDataGet.length, (_index) {
        var orgName = "";
        // Set the org name for the task from the list of available orgs
        if (organisationNameFormFinal.isNotEmpty) {
          orgName = organisationNameFormFinal[
                  taskDataGet[_index]["mapId"].toString()] ??
              "ERROR map name not found";
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskPageIN(
                  selectedIndex: _index,
                  getMapData: taskDataGet,
                  liveformLocation: orgName,
                ),
              ),
            );
          },
          child: SingleDashCardB(
            taskindex: _index,
            taskListData: SingleWorkTask.fromJson(taskDataGet[_index]),
            orgName: orgName,
          ),
        );
      }),
    );
  }
}
