import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/MapDownloader/MapImageDownloader.dart';
import 'package:farmhand/pages/dashboard.dart';
import 'package:farmhand/pages/noInternet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong/latlong.dart';
import 'package:geopoint/geopoint.dart';

extension MapImageDownloaderExt on MapImageDownloaderState {
  loadData() async {
    preferences = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 5), () {
      String mapIDInString =
          preferences.getString(SharedOfflineData().userMapIDsGot);

      if (mapIDInString != null && mapIDInString.isNotEmpty) {
        print("Map ID from Preference :: " + mapIDInString);
        List mapIDListgetINproject = json.decode(mapIDInString);
        print('mapID got in Project :: $mapIDListgetINproject');
        preferences.setString(
            SharedOfflineData().oldMapEntryCheckListString, mapIDInString);
        downloadTheMapProcess(mapIDListgetINproject);
      } else {
        print("COULD NOT FIND MAP ID - SKIP DOWNLOADING THE OFFLINE MAP");
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => FormHandDashboard(),
              ),
              (router) => false),
        );
      }
    });
  }

  downloadTheMapProcess(mapIDListgetINproject) {
    String geojsonData;

    for (var mapIDListgetINprojectItem in mapIDListgetINproject) {
      List<LatLng> geopoint = [];
      final polygons = <Polygon>[];
      geojsonData = preferences
          .getString(
              "$mapIDListgetINprojectItem-${SharedOfflineData().geojsonMapData}")
          .trim();

      final geojson = GeoJson();
      geojson.processedFeatures.listen((GeoJsonFeature feature) {
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

        if (mounted) {
          // ignore: invalid_use_of_protected_member
          setState(() {
            polygons.add(poly);
          });
        }
      }).onDone(() {
        List<LatLng> workinLatLng = [];
        for (Polygon item in polygons) {
          workinLatLng.addAll(item.points);
        }
        makeABoundsIn = LatLngBounds.fromPoints(workinLatLng);
        mapController?.fitBounds(makeABoundsIn);
        String mapIdandListStringData =
            preferences.getString(SharedOfflineData().mapidandNameList);
        List mapIdandListData;
        if (mapIdandListStringData != null &&
            mapIdandListStringData.isNotEmpty) {
          mapIdandListData = json.decode(mapIdandListStringData);
        }

        if (mapIdandListData != null) {
          for (var mapIdandListDataItem in mapIdandListData) {
            if (mapIdandListDataItem['id'] == mapIDListgetINprojectItem) {
              // ignore: invalid_use_of_protected_member
              setState(() {
                loadingMapName = mapIdandListDataItem['name'];
              });
            }
          }
        }

        checkTheCount.add(mapIDListgetINprojectItem);
        if (checkTheCount.length == mapIDListgetINproject.length) {
          Future.delayed(
            Duration(seconds: 3),
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => FormHandDashboard(),
                ),
                (router) => false),
          );
        }
        print("makeABoundsIn $mapIDListgetINprojectItem :: $makeABoundsIn");
        return polygons;
      });
      geojson.endSignal.listen((bool _) => geojson.dispose());
      final data = geojsonData;
      unawaited(geojson.parse(data, verbose: true));
    }
  }

  void checkInternetConnection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoInternetPage()),
          (route) => false);
    }
  }
}
