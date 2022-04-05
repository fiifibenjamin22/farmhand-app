import 'package:farmhand/pages/taskPage/Cards/SingleCardPaddockB.dart';
import 'package:farmhand/pages/taskPage/extensions/taskPaddockBExt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:geodesy/geodesy.dart';

LatLng currentpoint;

class CardB extends StatefulWidget {
  final List paddockNameList;
  final List paddocksRelatedToTaskList;
  final List<Polygon> polygonData;
  CardB(
      {this.polygonData, this.paddockNameList, this.paddocksRelatedToTaskList});

  @override
  CardBState createState() => CardBState();
}

class CardBState extends State<CardB> {
  List<Color> commonColors = [];
  List<String> buttonCheckString = [];

  @override
  void initState() {
    super.initState();
    // all the paddocks in the map
    List allPaddocksInMapIds = [];
    // paddocks to have tasks done on them
    List paddockIdsRelatedToTask = [];
    for (var paddockNameListItem in widget.paddockNameList) {
      allPaddocksInMapIds.add(paddockNameListItem['paddockId']);
    }
    for (var paddockTaskAllottedListItem in widget.paddocksRelatedToTaskList) {
      paddockIdsRelatedToTask.add(paddockTaskAllottedListItem['paddockId']);
    }

    for (var paddockAllTaskIdItem in allPaddocksInMapIds) {
      if (paddockIdsRelatedToTask.contains(paddockAllTaskIdItem)) {
        commonColors.add(Colors.red);
        buttonCheckString.add("Click to \nComplete");
      } else {
        commonColors.add(Colors.blue);
        buttonCheckString.add("Click to \nComplete");
      }
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation().then((value) {
      if (mounted) {
        setState(() {
          currentpoint = LatLng(value.latitude, value.longitude);
        });
      }
    });
    //click to complete button
    return currentpoint != null
        ? commonColors.contains(Colors.red) ||
                commonColors.contains(Colors.grey) ||
                commonColors.contains(Colors.green)
            ? Column(
                children: List.generate(
                  widget.polygonData.length,
                  (index) => SingleCardPaddockB(
                    polygonDataPoint: widget.polygonData[index].points,
                    paddockIndex: index,
                    commonColors: commonColors,
                    paddockName: widget.paddockNameList,
                    buttonCheckString: buttonCheckString,
                  ),
                ),
              )
            : Center(
                // child: Text("No Paddocks Task"),
                )
        : Center(
            child: Text("Loading current location..."),
          );
  }
}
