import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/mapViewAllWorkshopMark.dart';
import 'package:farmhand/pages/farmsMapViewTaskPaddock.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

extension MapViewAllWorkStationExtension on MapViewAllWorkShopState {
  processData(value) {
    print("value get ${value[0]} ${value[1]}");
    var workTaskMapId = value[0];
    var workshopLatlan = value[1];
    for (var i = 0; i < workshopLatlan.length; i++) {
      dummypoint.add(LatLng(workshopLatlan[i][1], workshopLatlan[i][0]));
      // ignore: invalid_use_of_protected_member
      setState(() {
        buttonMarker.add(
          Marker(
            width: 50.0,
            height: 50.0,
            point: dummypoint[i],
            builder: (ctx) => InkWell(
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              onTap: () {
                // ignore: invalid_use_of_protected_member
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapViewTask(
                        mapIdGet: workTaskMapId[i],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        );
      });
    }

    for (var butMarkitem in buttonMarker) {
      markers.add(butMarkitem);
    }

    if (widget.getStorageLocation) {
      var personDetailsJson = json.decode(
          Utils.getStringFromPreferences(SharedOfflineData().personDetails));
      List organisationList = personDetailsJson['organisations'];
      List<LatLng> storageLoactionLatLng = [];
      for (var organisationitem in organisationList) {
        for (var storagelocationsItem in organisationitem['storagelocations']) {
          storagelocationsItem['latitude'] = 27.175014;
          storagelocationsItem['longitude'] = 78.042152;
          storageLoactionLatLng.add(LatLng(storagelocationsItem['latitude'],
              storagelocationsItem['longitude']));
        }
      }

      print("Storage Location:: $storageLoactionLatLng");
      for (var storageLatLng in storageLoactionLatLng) {
        dummypoint.add(storageLatLng);
        storageMarker.add(
          Marker(
              width: 35.0,
              height: 35.0,
              point: storageLatLng,
              builder: (ctx) => InkWell(
                    child: Image.asset("assets/workshopIcon.png"),
                    onTap: () {
                      // ignore: invalid_use_of_protected_member
                      setState(() {});
                    },
                  )),
        );
      }
      for (var storeMarkitem in storageMarker) {
        markers.add(storeMarkitem);
      }
    }

    makeABoundsIn = LatLngBounds.fromPoints(dummypoint);
  }

  longLatData(LatLngData ld) {
    if (ld == null || ld.location == null) {
      return;
    }
    if (mounted) {
      if (flagforlivedelay) mapController?.move(ld.location, 17);
      // ignore: invalid_use_of_protected_member
      setState(() {
        markers = [];
        if (storageLoctaioncCheck) {
          for (var i = 0; i < storageMarker.length; i++) {
            markers.add(storageMarker[i]);
          }
        }
        for (var i = 0; i < buttonMarker.length; i++) {
          markers.add(buttonMarker[i]);
        }
        markers.add(liveMarkerList.first);
        flagforlivedelay = !flagforlivedelay;
      });
    }
  }

  addRemoveMarker() {
    storageLoctaioncCheck = !storageLoctaioncCheck;
    if (storageLoctaioncCheck) {
      for (var i = 0; i < storageMarker.length; i++) {
        markers.add(storageMarker[i]);
        markers.add(Marker());
      }
    } else {
      for (var i = 0; i < storageMarker.length; i++) {
        markers.remove(storageMarker[i]);
      }
    }
  }
}
