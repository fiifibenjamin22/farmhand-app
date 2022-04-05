import 'dart:async';
import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/pages/taskPage/taskPage.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';
import 'package:geopoint/geopoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

extension TaskProcesData on TaskPageINState {
  Future processData(geojsonData) async {
    final geojson = GeoJson();

    geojson.processedFeatures.listen((GeoJsonFeature feature) {
      final geoSerie = GeoSerie(
        type: GeoSerieType.polygon,
        name: feature.geometry.name,
        geoPoints: <GeoPoint>[],
      );

      for (final serie in feature.geometry.geoSeries) {
        GeoSerie queen = serie;

        for (GeoPoint item in queen.geoPoints) {
          geopoint.add(item.toLatLng());
        }

        geoSerie.geoPoints.addAll(serie.geoPoints);
      }

      final poly = Polygon(
        points: geoSerie.toLatLng(ignoreErrors: true),
        color: Colors.transparent, //Color(0xff7778ED),
        borderStrokeWidth: 1.0,
        borderColor: Colors.red,
      );
      paddockNames.add({
        "name": feature.properties['paddockName'],
        "paddockId": feature.properties['paddockID'],
        "latlngPoint": geoSerie.toLatLng(ignoreErrors: true)
      });
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(() {
          polygons.add(poly);
        });
      }

      if (feature.properties['labelLocation'] != null) {
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
        for (var gpsLocationMapID in workTaskSingleData.gpsLocations) {
          if (feature.properties['paddockID'] == gpsLocationMapID.paddockId) {
            paddockTaskAllottedList.add({
              "name": gpsLocationMapID.name,
              "paddockId": gpsLocationMapID.paddockId,
              "latlngPoint": geoSerie.toLatLng(ignoreErrors: true)
            });
          }
        }
      }
    }).onDone(() {
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(() {
          if (polygons.isNotEmpty) {
            makeChange = false;
          } else {
            makeChange = false;
          }
        });
      }
      return polygons;
    });
    geojson.endSignal.listen((bool _) => geojson.dispose());
    final data = geojsonData;
    unawaited(geojson.parse(data, verbose: true));
  }

  // Load data
  Future loadData() async {
    preference = await SharedPreferences.getInstance();

    String workTaskDatas =
        preference.getString(SharedOfflineData().workTasksDetails);
    List decodeWorkTaskDatasList = json.decode(workTaskDatas);
    String mapIdStr = preference.getString(SharedOfflineData().mapidList);
    List mapIdList;
    if (mapIdStr != null && mapIdStr.isNotEmpty) {
      mapIdList = json.decode(mapIdStr);
      for (var decodeWorkTaskDatasListitem in decodeWorkTaskDatasList) {
        if (decodeWorkTaskDatasListitem['id'] ==
            widget.getMapData[widget.selectedIndex]['id']) {
          workTaskSingleData =
              SingleWorkTask.fromJson(decodeWorkTaskDatasListitem);
        }
      }
    } else {
      print("mapIdStr is EMPTY..!!!");
    }

    if (mapIdList != null &&
        mapIdList.contains(widget.getMapData[widget.selectedIndex]['mapId'])) {
      String geoJsonDataInString = preference
          .getString(
              "${widget.getMapData[widget.selectedIndex]['mapId']}-${SharedOfflineData().geojsonMapData}")
          .trim();
      processData(geoJsonDataInString);
      print(
          "${widget.getMapData[widget.selectedIndex]['mapId']} Mapid available local");
    } else {
      allAPIofFarmHand
          .mapWorktask(widget.getMapData[widget.selectedIndex]['mapId'])
          .then((value) => processData(value))
          .catchError((e) {
        showToast(e.toString(), context,
            durationIN: 3, gravityIN: Toast.BOTTOM);
      });
      print(
          "${widget.getMapData[widget.selectedIndex]['mapId']} Mapid not available local");
    }
  }
}
