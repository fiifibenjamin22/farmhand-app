import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/farmsMapViewTaskPaddock.dart';
import 'package:farmhand/pages/taskPage/SingleCardNoteC.dart';
import 'package:farmhand/pages/taskPage/finishedTaskPage.dart';
import 'package:farmhand/pages/taskPage/taskpaddockB.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_showConfirmAlert.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as fhGeoLocator;
import 'package:latlong/latlong.dart';
import 'package:geopoint/geopoint.dart';
import 'package:toast/toast.dart';

extension MapViewTaskStateExtension on MapViewTaskState {
  loadData() async {
    preferences = await SharedPreferences.getInstance();
    if (widget.changeMethod) {
      polygons = widget.changeMethodPolygon;
      for (Polygon item in polygons) {
        workinLatLng.addAll(item.points);
      }
      paddockLabelMarkesList = widget.paddockworktasklabelList;
      makeABoundsIn = LatLngBounds.fromPoints(workinLatLng);
      List mapidAndnameList = json
          .decode(preferences.getString(SharedOfflineData().mapidandNameList));
      for (var idAndNameitem in mapidAndnameList) {
        if (idAndNameitem["organisationID"] == widget.mapIdGet) {
          formNameget = idAndNameitem['name'];
        }
      }
      labelAddAndRemove(!paddockLabelVisiblity);
      //print("true to call without storageLocation and grazed");
    } else {
      //print(":::::::----->false to call storageLocation and grazed");
      allAPIofFarmHand.mapWorktask(widget.mapIdGet).then((value) => {
            if (value != null) {processData(value)}
          });
      List mapidAndnameList = json
          .decode(preferences.getString(SharedOfflineData().mapidandNameList));
      //print("mapidAndnameList:::--------->$mapidAndnameList");
      for (var idAndNameitem in mapidAndnameList) {
        if (idAndNameitem["id"] == widget.mapIdGet) {
          formNameget = idAndNameitem['name'];
        }
      }
    }
    determinePosition();
  }

  //get the area of the polygon
  // double getPolygonArea(
  //     List<LatLng> points, List<Marker> paddockLabelMarkesList) {
  //   //print("points:::::::::::::::----->$points,\n\n\n\n${points.length}");
  //   double area = 0.0;
  //   List<double> areas = [];
  //   for (var i = 0; i < points.length - 1; i++) {
  //     area += distanceBetweenTwoPoints(points[i].latitude, points[i].longitude,
  //         points[i + 1].latitude, points[i + 1].longitude);
  //     areas.add(area);
  //   }
  //   //sum the areas
  //   double sumOfAreas = 0.0;
  //   for (var i = 0; i < areas.length; i++) {
  //     sumOfAreas += areas[i];
  //   }

  //   //convert area to px
  //   double areaPx = sumOfAreas *
  //       (MediaQuery.of(context).size.width /
  //           MediaQuery.of(context).size.height);

  //   if (areaPx < 1.5) {
  //     return (areaPx * paddockLabelMarkesList.length) * 3.7;
  //   } else {
  //     return 0.0;
  //   }
  // }

  //get the area of the polygon
  double getPolygonArea(List<LatLng> points) {
    print("get polygon area");
    double area = 0.0;
    List<double> areas = [];
    for (var i = 0; i < points.length - 1; i++) {
      area += distanceBetweenTwoPoints(points[i].latitude, points[i].longitude,
          points[i + 1].latitude, points[i + 1].longitude);
      areas.add(area);
    }

    print("areas:::----->$areas");

    //sum the areas
    double sumOfAreas = 0.0;
    for (var i = 0; i < areas.length; i++) {
      sumOfAreas += areas[i];
    }

    print("sumOfAreas:::----->$sumOfAreas");

    //convert area to px
    double areaPx = sumOfAreas *
        (MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height);
    print("areaPx:::----->$areaPx");

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

  // Function to find the current position while loading the Paddock Screen - IPS
  Future<fhGeoLocator.Position> determinePosition() async {
    bool serviceEnabled;
    fhGeoLocator.LocationPermission permission;
    serviceEnabled = await fhGeoLocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await fhGeoLocator.Geolocator.checkPermission();
    if (permission == fhGeoLocator.LocationPermission.denied) {
      permission = await fhGeoLocator.Geolocator.requestPermission();
      if (permission == fhGeoLocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == fhGeoLocator.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await fhGeoLocator.Geolocator.getCurrentPosition();
  }

  // <------ paddock processing function ------>
  Future<void> processData(geojsonData) async {
    final geojson = GeoJson();

    geojson.processedFeatures.listen((GeoJsonFeature feature) {
      Marker paddockLabel = Marker(
        builder: (context) => Text(
          feature.properties['paddockName'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        point: LatLng(
          feature.properties['labelLocation'][1],
          feature.properties['labelLocation'][0],
        ),
      );
      paddockLabelMarkesList.add(paddockLabel);

      final geoSerie = GeoSerie(
          type: GeoSerieType.polygon,
          name: feature.geometry.name,
          geoPoints: <GeoPoint>[]);
      for (final serie in feature.geometry.geoSeries) {
        GeoSerie queen = serie;

        for (GeoPoint item in queen.geoPoints) {
          geopoint.add(item.toLatLng());
        }

        geoSerie.geoPoints.addAll(serie.geoPoints);
      }

      final poly = Polygon(
          points: geoSerie.toLatLng(ignoreErrors: true),
          color: Color(0xff7778ED),
          borderStrokeWidth: 1.0,
          borderColor: Colors.red);
      Map<String, dynamic> paddockDataGetter = {
        "name": feature.properties['paddockName'],
        "paddockID": feature.properties['paddockID'],
        "coordinates": geoSerie.toLatLng(ignoreErrors: true)
      };
      makePaddockchangeData.add(paddockDataGetter);
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(() {
          polygons.add(poly);
          workinLatLng = [];
          for (Polygon item in polygons) {
            workinLatLng.addAll(item.points);
          }
          makeABoundsIn = LatLngBounds.fromPoints(workinLatLng);

          zoomLevel = getPolygonArea(workinLatLng);
          minZoomLevel = zoomLevel;
          print("map zoom level:::::---------> $zoomLevel");
        });
      }

      for (var i in 0.to(polygons.length)) {
        this.paddockLabelMarkesList.add(paddockLabel);
      }
    }).onDone(() {
      labelAddAndRemove(!paddockLabelVisiblity);
      FitBoundsOptions options = FitBoundsOptions(padding: EdgeInsets.all(1));
      if (mapController != null && makeABoundsIn != null && options != null) {
        mapController.fitBounds(makeABoundsIn, options: options);
      }
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());

    final data = geojsonData.toString();

    unawaited(geojson.parse(data, verbose: true));
  }

  /// WRITTEN BY IPS
  changePaddockColor(LatLng point, bool selectedFromDropDown) {
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

      junkColor = element.color;
      int index = polygons.indexOf(element);
      selectedIndex = index;
      var yellowColor = Color(0xffffff00);

      var selectedPolygonColor = polygons[selectedIndex].color;

      polygons[index] = Polygon(
        points: element.points,
        color: Color(0xff7778ED),
        borderStrokeWidth: 1.0,
        borderColor: Colors.red,
      );

      if (isGeoPointInPolygen == true) {
        paddockTapped = true;
        foundSearchedPaddock = true;
        // ignore: invalid_use_of_protected_member
        setState(() {
          /// If a paddock is selected from Dropdown, make it to the center of the screen
          if (selectedFromDropDown) {
            mapController?.move(point, 17);
          }

          /// If the previously selected index and the current index are same and if it is
          /// highlighted from Search / Dropdown Selection dont unselect the Paddock.
          // if (selectedIndex == index && selectedFromDropDown) {
          //   print("Already Highlighted.. DO NOTHING..!!!");
          //   return;
          // }

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

          if (widget.changeMethod) {
            workTaskEditDatainMap(element.points);
          }
        });
      }
    });

    //Removing the highlighted paddock when tapped on the map other than the Paddocks
    if (paddockTapped == false) {
      if (selectedIndex > 0 && changeColor) {
        polygons.removeAt(selectedIndex);
        polygons.add(
          Polygon(
            points: selectedLatLngValue,
            color: Color(0xff7778ed),
            borderStrokeWidth: 1.0,
            borderColor: Colors.red,
          ),
        );
        makeChange = true;
      }
      selectedIndex = -1;
    }
    setState(() {
      minZoomLevel = 0.0;
    });
  }

  //<------ This function use to set as grazed ------>
  polygonChange(Polygon getpoint) {
    // ignore: invalid_use_of_protected_member
    setState(() {
      var namekey;
      var namePaddock;
      for (var makePaddockchangeDataItem in makePaddockchangeData) {
        if (makePaddockchangeDataItem['coordinates'].toSet().toString() ==
            getpoint.points.toSet().toString()) {
          namekey = makePaddockchangeDataItem['paddockID'];
          namePaddock = makePaddockchangeDataItem['name'];
        }
      }
      Map<String, dynamic> grazedPostbody = {
        "paddockEventTypeId": 2,
        "startDateTime": DateTime.now().toString(),
        "endDateTime": DateTime.now().toString(),
        "paddocks": [
          {
            "key": namekey,
            "value": {
              "latitude": getpoint.points.first.latitude,
              "longitude": getpoint.points.first.longitude,
              "time": DateTime.now().toString()
            }
          }
        ]
      };
      allAPIofFarmHand.paddocksGrazedAPI(grazedPostbody).then((value) {
        if (value[0]) {
          // this is being hidden for now as the functionality of non available
          // paddocks needs to be redesigned
          //polygons.removeAt(polygons.indexOf(getpoint));
          //polygons.add(Polygon(
          //    points: getpoint.points,
          //    color: Colors.pink,
          //   borderStrokeWidth: 1.0,
          //    borderColor: Colors.red));
          showToast("$namePaddock ${value[1]}", context,
              durationIN: 3, gravityIN: Toast.BOTTOM);
        } else {
          showToast("$namePaddock ${value[1]}", context,
              durationIN: 3, gravityIN: Toast.BOTTOM);
        }
      });
    });
  }

  setAsGrazedFn(currentPolygon) {
    // ignore: invalid_use_of_protected_member
    setState(() {
      bool checkLocationPaddock =
          geodesy.isGeoPointInPolygon(currentPoint, currentPolygon.points);

      if (checkLocationPaddock) {
        print("In the Paddock");
        polygonChange(currentPolygon);
      } else {
        print("You are Away");
        showConfirmationPopup(context, currentPolygon);
      }
      makeChange = true;
    });
  }

  showConfirmationPopup(BuildContext context, currentPolygon) {
    showConfirmationDialog(context,
        "Your location does not match with Paddock Location. Are you sure you want to complete this task?",
        () {
      polygonChange(currentPolygon);
      Navigator.pop(context);
    }, true);
  }

  //<------ This function use to add the label and remove ------>
  labelAddAndRemove(resultofvisibility) async {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        if (resultofvisibility) {
          // allMarkers.clear();
          for (var markerItems in paddockLabelMarkesList) {
            allMarkers.remove(markerItems);
          }
        } else {
          // allMarkers = lableMark;
          for (var markerItems in paddockLabelMarkesList) {
            allMarkers.add(markerItems);
          }
        }
      });
    }
  }
//<------ End ------>

//<------ This function use to give the task for Each paddock on map ----->
  workTaskEditDatainMap(List<LatLng> pointsGet) {
    if (workTaskmarkerEdit != null) {
      // ignore: invalid_use_of_protected_member
      setState(() {
        allMarkers.remove(workTaskmarkerEdit);
        allMarkers.add(Marker());
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
                paddocksRelatedToTaskList: widget.paddockAllottedTaskList),
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
                : Column(children: [SingleCardNoteC(), WorkTaskFinish()])
          ],
        ),
      );

      allMarkers.add(workTaskmarkerEdit);
      //allMarkers.add(Marker());
    }
  }
//<------ End ------>

//<------ This Function use to Check the completed paddock ------>
  checkpaddockCompleted(String mapidString) {
    String completeString = Utils.getStringFromPreferences(
        "${SharedOfflineData().completedPaddockTaskLocalSave}-${int.parse(mapidString)}");
    String localString = Utils.getStringFromPreferences(
        "${SharedOfflineData().paddockTaskLocalSave}-${int.parse(mapidString)}");
    List paddockTaskLocalSave =
        localString.isNotEmpty ? json.decode(localString) : [];
    List completedPaddockTaskLocalSave =
        completeString.isNotEmpty ? json.decode(completeString) : [];
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
    List paddockAllottedTaskid = [];
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
                  borderColor: Colors.red);
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
            if (paddockAllottedTaskid
                .contains(paddockAllTaskItem['paddockId'])) {
            } else {
              var changepoly = Polygon(
                  points: polygonsitem.points,
                  color: Colors.transparent,
                  borderStrokeWidth: 1.0,
                  borderColor: Colors.red);
              polygons.add(changepoly);
              polygons.remove(polygonsitem);
            }
          }
        }
      }

      completedPolyflag = false;
    }
  }
//<------ End ------>

//<------ This Function use to Check the Internet Connection ----->
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

  _searchPaddockColorChange(int index) {
    int resultInt = int.tryParse(searchResult[index]);

    foundSearchedPaddock = false;
    var selectedFromDropDown = true;
    for (var makePaddockchangeDataItem in makePaddockchangeData) {
      if (resultInt.toString().toLowerCase() ==
          makePaddockchangeDataItem['name'].toString().toLowerCase()) {
        for (int i = 0;
            i < makePaddockchangeDataItem['coordinates'].length;
            i++) {
          if (foundSearchedPaddock) {
            break;
          }
          changePaddockColor(makePaddockchangeDataItem['coordinates'][i],
              selectedFromDropDown);
        }
      }
    }
    searchResult = [];
    FocusScope.of(context).unfocus();
  }

  textSearchBoxFn(val) {
    List tempSearchResult = [];
    if (val.toString().isNotEmpty) {
      for (var makePaddockchangeDataItem in makePaddockchangeData) {
        var nameSearch =
            makePaddockchangeDataItem['name'].toString().toLowerCase();
        if (nameSearch.startsWith(val.toString().toLowerCase())) {
          String paddockName = makePaddockchangeDataItem['name'].toString();
          tempSearchResult.add(paddockName);
        }
      }
    }
    searchResult = tempSearchResult..sort();
    if (tempSearchResult.isEmpty && val.toString().isNotEmpty) {
      showToast("No paddocks found", context,
          durationIN: 3, gravityIN: Toast.TOP);
    }
  }

  onSelectingSearchResult(getindex) {
    searchPaddockColorChangebool = true;
    _searchPaddockColorChange(getindex);
  }
//<------ End ------>

  Future<fhGeoLocator.Position> getCurrentLocation() async {
    bool serviceEnabled;
    fhGeoLocator.LocationPermission permission;

    serviceEnabled = await fhGeoLocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await fhGeoLocator.Geolocator.checkPermission();
    if (permission == fhGeoLocator.LocationPermission.denied) {
      permission = await fhGeoLocator.Geolocator.requestPermission();
      if (permission == fhGeoLocator.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == fhGeoLocator.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await fhGeoLocator.Geolocator.getCurrentPosition(
      desiredAccuracy: fhGeoLocator.LocationAccuracy.high,
    );
  }
}

extension RangeExtension on int {
  List<int> to(int maxInclusive) =>
      [for (int i = this; i <= maxInclusive; i++) i];
}

// extension RangeExtension on int {
//   List<int> to(int maxInclusive, {int step = 1}) =>
//       [for (int i = this; i <= maxInclusive; i += step) i];
// }
