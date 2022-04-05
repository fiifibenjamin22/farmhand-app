import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/ShowTaskInMapView.dart';
import 'package:farmhand/pages/taskPage/SingleCardNoteC.dart';
import 'package:farmhand/pages/taskPage/finishedTaskPage.dart';
import 'package:farmhand/pages/taskPage/taskpaddockB.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_broadcast_receiver/flutter_broadcast_receiver.dart';

extension TaskInMapExtension on TaskInMapViewState {
  //load data from shared pref
  loadData() async {
    preference = await SharedPreferences.getInstance();

    polygons = widget.changeMethodPolygon;
    for (Polygon item in polygons) {
      workinLatLng.addAll(item.points);
    }
    paddockLabelMarkesList = widget.paddockworktasklabelList;
    makeABoundsIn = LatLngBounds.fromPoints(workinLatLng);
    String mapidandName =
        preference.getString(SharedOfflineData().mapidandNameList);
    List mapidAndnameList = [];
    if (mapidandName != null && mapidandName.isNotEmpty) {
      mapidAndnameList = json.decode(mapidandName);
    }
    for (var idAndNameitem in mapidAndnameList) {
      if (idAndNameitem["id"] == widget.mapIdGet) {
        formNameget = idAndNameitem['name'];
      }
    }

    for (var i in 0.to(polygons.length)) {
      labelAddAndRemove(!paddockLabelVisiblity);
    }

    //print("workinLatLng:::::::-------->$workinLatLng");
    countPaddockInPolygon(workinLatLng);
    if (widget.paddockNameList.length > 7) {
      zoomLevel = 12;
    } else {
      zoomLevel = getPolygonArea(workinLatLng);
    }
  }

  //change paddock color
  changePaddockColor(LatLng point) {
    print("::::::------>load bottom sheet in map");

    polygons.forEach((element) {
      bool isGeoPointInPolygen = false;

      try {
        isGeoPointInPolygen =
            geodesy.isGeoPointInPolygon(point, element.points);
      } catch (e) {
        print("Exception in Geodesy :: " + e.toString());
        isGeoPointInPolygen = null;
        return;
      }

      if (isGeoPointInPolygen == null) {
        return;
      }

      int index = polygons.indexOf(element);
      selectedIndex = index;
      var yellowColor = Color(0xffffff00);

      var selectedPolygonColor = polygons[selectedIndex].color;

      polygons[index] = Polygon(
        points: element.points,
        color: Colors.transparent,
        borderStrokeWidth: 1.0,
        borderColor: Colors.red,
      );

      if (isGeoPointInPolygen == true) {
        paddockTapped = true;

        // ignore: invalid_use_of_protected_member
        setState(() {
          /// If the previously selected index and the current index are same and if it is
          /// highlighted don't unselect the Paddock.
          if (selectedIndex != index) {
            print("Already Highlighted.. DO NOTHING..!!!");
            return;
          }

          junkColor = element.color;

          var activeColor = selectedPolygonColor == yellowColor
              ? Color(0xff7778ED)
              : yellowColor;

          polygons[selectedIndex] = Polygon(
            points: element.points,
            color: activeColor,
            borderStrokeWidth: 1.0,
            borderColor: Colors.red,
          );

          selectedPolygonColor == yellowColor
              ? makeChange = true
              : makeChange = false;

          //selectedIndex = index;
          selectedLatLngValue = element.points;
          polygonLastData = element.points;

          if (loadBottomSheet != null) {
            print(polygons[selectedIndex].color);
            _loadBottomSheet(element.points);
          }
        });
      }
    });

    // Removing the highlighted paddock when tapped on the map other than the Paddocks
    if (paddockTapped == false) {
      if (workTaskmarkerEdit != null) {
        // ignore: invalid_use_of_protected_member
        setState(() {
          allMarkers.remove(workTaskmarkerEdit);
        });
      }
      if (selectedIndex > 0 && changeColor) {
        polygons.removeAt(selectedIndex);

        polygons.add(
          Polygon(
            points: selectedLatLngValue,
            color: Colors.green,
            borderStrokeWidth: 1.0,
            borderColor: Colors.red,
          ),
        );
        makeChange = true;
      }
      selectedIndex = -1;
    }
  }

  //This function use to add the label and remove
  labelAddAndRemove(resultofvisibility) async {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        if (resultofvisibility) {
          for (var markerItems in paddockLabelMarkesList) {
            allMarkers.remove(markerItems);
          }
        } else {
          for (var markerItems in paddockLabelMarkesList) {
            //print("markerItems:::$markerItems");
            allMarkers.add(markerItems);
          }
        }
      });
    }
  }

  workTaskEditDatainMap(List<LatLng> pointsGet) {
    if (workTaskmarkerEdit != null) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        allMarkers.remove(workTaskmarkerEdit);
      });
    }

    if (mounted) {
      List<Polygon> newEdited = [];
      List paddocknameList = [];

      for (var i = 0; i < polygons.length; i++) {
        if (polygons[i].points.toSet().toString() ==
            pointsGet.toSet().toString()) {
          newEdited.add(polygons[i]);
        }
      }

      for (var i = 0; i < widget.paddockNameList.length; i++) {
        if (widget.paddockNameList[i]['latlngPoint'].toSet().toString() ==
            pointsGet.toSet().toString()) {
          paddocknameList.add(widget.paddockNameList[i]);
        }
      }

      bool valuechangeIn = true;
      workTaskmarkerEdit = Marker(
        width: 200,
        height: 500,
        point: pointsGet.first,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CardB(
              polygonData: newEdited,
              paddockNameList: paddocknameList,
              paddocksRelatedToTaskList: widget.paddockAllottedTaskList,
            ),
            valuechangeIn
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // ignore: invalid_use_of_protected_member
                        setState(() {
                          valuechangeIn = false;
                        });
                      },
                      child: Text("Add Note"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF336BAB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      SingleCardNoteC(),
                      WorkTaskFinish(),
                    ],
                  ),
          ],
        ),
      );
      allMarkers.add(workTaskmarkerEdit);
    }
  }

  //This Function use to Check the completed paddock
  checkpaddockCompleted(String mapidString) {
    String completeString = Utils.getStringFromPreferences(
        "${SharedOfflineData().completedPaddockTaskLocalSave}-${int.parse(mapidString)}");
    String localString = Utils.getStringFromPreferences(
        "${SharedOfflineData().paddockTaskLocalSave}-${int.parse(mapidString)}");
    List paddockTaskLocalSave =
        localString.isNotEmpty ? json.decode(localString) : [];
    List completedPaddockTaskLocalSave =
        completeString.isNotEmpty ? json.decode(completeString) : [];
    // print("bk gets $paddockTaskLocalSave  $completedPaddockTaskLocalSave");
    List getCompletedID = [];
    List getCompletedLatLng = [];
    for (var completedPaddockTaskLocalSaveItem
        in completedPaddockTaskLocalSave) {
      getCompletedID.add(completedPaddockTaskLocalSaveItem['key']);
    }
    for (var paddockTaskLocalSaveItem in paddockTaskLocalSave) {
      getCompletedID.add(paddockTaskLocalSaveItem['key']);
    }
    for (var getCompletedIDItem in getCompletedID.toSet().toList()) {
      for (var paddockNameListItem in widget.paddockNameList) {
        if (getCompletedIDItem == paddockNameListItem['paddockId']) {
          getCompletedLatLng.add(paddockNameListItem['latlngPoint']);
        }
      }
    }

    for (var paddockTaskAllottedListItem in widget.paddockAllottedTaskList) {
      paddockAllottedTaskid.add(paddockTaskAllottedListItem['paddockId']);
    }

    if (localSaveCount != paddockTaskLocalSave.length ||
        completeSaveCount != completedPaddockTaskLocalSave.length) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        completedPolyflag = true;
      });
    }

    for (var paddockAllTaskItem in widget.paddockNameList) {
      for (var polygonsitem in polygons) {
        if (listEquals(paddockAllTaskItem['latlngPoint'].toSet().toList(),
            polygonsitem.points.toSet().toList())) {
          var currentPolygon;
          if (paddockAllottedTaskid.contains(paddockAllTaskItem['paddockId'])) {
            currentPolygon = Polygon(
              points: polygonsitem.points,
              color: Colors.green,
              borderStrokeWidth: 1.0,
              borderColor: Colors.red,
            );
          } else {
            currentPolygon = Polygon(
              points: polygonsitem.points,
              color: Colors.transparent,
              borderStrokeWidth: 1.0,
              borderColor: Colors.red,
            );
          }
          polygons.add(currentPolygon);
          polygons.remove(polygonsitem);
        }
      }
    }

    if (completedPolyflag) {
      localSaveCount = paddockTaskLocalSave.length;
      completeSaveCount = completedPaddockTaskLocalSave.length;
      for (List<LatLng> getCompletedLatLngItem in getCompletedLatLng) {
        for (var polygonsitem in polygons) {
          // ignore: invalid_use_of_protected_member
          setState(() {
            if (listEquals(getCompletedLatLngItem.toSet().toList(),
                polygonsitem.points.toSet().toList())) {
              var changepoly = Polygon(
                points: polygonsitem.points,
                color: Colors.grey,
                borderStrokeWidth: 1.0,
                borderColor: Colors.red,
              );
              polygons.add(changepoly);
              polygons.remove(polygonsitem);
            }
          });
        }
      }
      for (var paddockAllTaskItem in widget.paddockNameList) {
        for (var polygonsitem in polygons) {
          if (listEquals(paddockAllTaskItem['latlngPoint'].toSet().toList(),
              polygonsitem.points.toSet().toList())) {
            var currentPolygon;
            if (paddockAllottedTaskid
                .contains(paddockAllTaskItem['paddockId'])) {
              currentPolygon = Polygon(
                points: polygonsitem.points,
                color: Colors.green,
                borderStrokeWidth: 1.0,
                borderColor: Colors.red,
              );
            } else {
              currentPolygon = Polygon(
                points: polygonsitem.points,
                color: Colors.transparent,
                borderStrokeWidth: 1.0,
                borderColor: Colors.red,
              );
            }
            polygons.add(currentPolygon);
            polygons.remove(polygonsitem);
          }
        }
      }

      completedPolyflag = false;
    }
  }

  void checkInternetConnection() async {
    final directory = await getApplicationDocumentsDirectory();
    systemLocation = directory.path;
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        checkInternet = false;
      });
    }
    if (mounted)
      // ignore: invalid_use_of_protected_member
      setState(() {
        checkInternet = true;
      });
  }

  void buildLiveMap() {
    if (livemap != null) {
      return;
    }
    livemap = LocationOptions(
      markers: allMarkers,
      onLocationUpdate: (LatLngData ld) {},
      onLocationRequested: (LatLngData ld) {
        if (mounted) {
          if (flagforlivedelay) {
            mapController?.move(ld.location, 17);
          }
          flagforlivedelay = true;
        }
      },
      buttonBuilder: (BuildContext context,
          ValueNotifier<LocationServiceStatus> status, Function onPressed) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "button1",
                  mini: true,
                  onPressed: () {
                    // ignore: invalid_use_of_protected_member
                    setState(
                      () {
                        labelAddAndRemove(paddockLabelVisiblity);
                        if (paddockLabelMarkesList.isEmpty) {
                          showToast("labelLocation got empty", context,
                              durationIN: 3, gravityIN: Toast.BOTTOM);
                        }
                        paddockLabelVisiblity = !paddockLabelVisiblity;
                      },
                    );
                  },
                  child: paddockLabelVisiblity
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  heroTag: "button2",
                  backgroundColor: Colors.blue,
                  child: ValueListenableBuilder<LocationServiceStatus>(
                    valueListenable: status,
                    builder: (BuildContext context, LocationServiceStatus value,
                        Widget child) {
                      switch (value) {
                        case LocationServiceStatus.disabled:
                        case LocationServiceStatus.permissionDenied:
                        case LocationServiceStatus.unsubscribed:
                          return const Icon(
                            Icons.location_disabled,
                            color: Colors.white,
                          );
                          break;
                        case LocationServiceStatus.subscribed:
                          return Icon(
                            Icons.my_location,
                            color: Colors.white,
                          );
                        default:
                          return const Icon(
                            Icons.location_searching,
                            color: Colors.white,
                          );
                          break;
                      }
                    },
                  ),
                  onPressed: () => onPressed(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _loadBottomSheet(List<LatLng> pointsGet) {
    print("pointsGet");
    loadBottomSheet = false;
    List<Polygon> newEdited = [];
    List paddocknameList = [];

    for (var i = 0; i < polygons.length; i++) {
      if (polygons[i].points.toSet().toString() ==
          pointsGet.toSet().toString()) {
        newEdited.add(polygons[i]);
      }
    }

    for (var i = 0; i < widget.paddockNameList.length; i++) {
      if (widget.paddockNameList[i]['latlngPoint'].toSet().toString() ==
          pointsGet.toSet().toString()) {
        paddocknameList.add(widget.paddockNameList[i]);
      }
    }

    // Check if the paddock is one of the task paddocks
    if (widget.paddockAllottedTaskList.any((taskPaddocks) =>
        paddocknameList.any((selectedPaddock) =>
            taskPaddocks["paddockId"] == selectedPaddock["paddockId"]))) {
      // Make modal to mark paddock as done

    /// closing the modal
    BroadcastReceiver().subscribe<String> // Data Type returned from publisher
        ('POP_CLOSE_EVENT', (message) {
      Navigator.of(context).pop();
    });
      showModalBottomSheet(
        isDismissible: true,
        context: context,
          builder: (BuildContext bc) {
            print("pointsGet $paddocknameList");
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CardB(
                      polygonData: newEdited,
                      paddockNameList: paddocknameList,
                      paddocksRelatedToTaskList: widget.paddockAllottedTaskList,
                    ),
                    // Column(
                    //   children: [
                    //     SingleCardNoteC(),
                    //     WorkTaskFinish(),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }).whenComplete(
        () => {
        changePaddockColor(
          LatLng(0.0, 0.0),
        ),
        },
      );
    }
  }

  //count the number of paddocks in the polygon
  int countPaddockInPolygon(List<LatLng> points) {
    int count = 0;
    for (var i = 0; i < widget.paddockNameList.length; i++) {
      if (widget.paddockNameList[i]['latlngPoint'].toSet().toString() ==
          points.toSet().toString()) {
        count++;
      }
    }
    return count;
  }

  //get the area of the polygon
  double getPolygonArea(List<LatLng> points) {
    double area = 0.0;
    List<double> areas = [];
    for (var i = 0; i < points.length - 1; i++) {
      area += distanceBetweenTwoPoints(points[i].latitude, points[i].longitude,
          points[i + 1].latitude, points[i + 1].longitude);
      areas.add(area);
    }
    //sum the areas
    double sumOfAreas = 0.0;
    for (var i = 0; i < areas.length; i++) {
      sumOfAreas += areas[i];
    }

    //convert area to px
    double areaPx = sumOfAreas *
        (MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height);
    // This code is being removed because it cause the zoom level down the chain to be NaN
    // return (areaPx * widget.paddockNameList.length) * 3.7;
    if (areaPx < 1.5) {
      print("areaPx < 1.5 ${areaPx * paddockLabelMarkesList.length * 1.0}");
      return (areaPx * paddockLabelMarkesList.length) * 0.99;
    } else {
      print("areaPx > 1.5");
      return 0.0;
    }
  }

  //distanceBetweenTwoPoints
  double distanceBetweenTwoPoints(
      double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    return dist;
  }

  //deg2rad
  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  //rad2deg
  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }
}

extension RangeExtension on int {
  List<int> to(int maxInclusive) =>
      [for (int i = this; i <= maxInclusive; i++) i];
}
