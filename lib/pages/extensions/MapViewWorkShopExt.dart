import 'dart:convert';

import 'package:farmhand/pages/farmsMapViewTaskPaddock.dart';
import 'package:farmhand/pages/mapViewWorkshopMark.dart';
import 'package:farmhand/widgets/reusables/Commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong/latlong.dart';

extension MapViewWorkShopExtension on MapViewWorkShopState {
  Future<void> processData(value) async {
    var decodejson = json.decode(value);
    initialWorkList = decodejson['features'][0]['geometry']['coordinates'][0];
    dummypoint = LatLng(initialWorkList[0][1], initialWorkList[0][0]);
    for (var item in initialWorkList) {
      workinLatLng.add(LatLng(item[1], item[0]));
    }
    markers.add(
      Marker(
        width: 50.0,
        height: 50.0,
        point: dummypoint,
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
                    mapIdGet: widget.mapIdGet,
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
    // ignore: invalid_use_of_protected_member
    setState(() {
      makeABoundsIn = LatLngBounds(workinLatLng.first, workinLatLng.last);
    });
    mapController?.fitBounds(LatLngBounds(dummypoint));
  }

  Marker buttonMarker() {
    return Marker(
      width: 50.0,
      height: 50.0,
      point: dummypoint,
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
                  mapIdGet: widget.mapIdGet,
                ),
              ),
            );
          });
        },
      ),
    );
  }

  LocationOptions userLocationOptions() {
    return LocationOptions(
      markers: markers,
      onLocationUpdate: (LatLngData ld) {
        markers.add(buttonMarker());
      },
      onLocationRequested: (LatLngData ld) {
        mapController?.move(ld.location, mapController.zoom);
        markers.add(buttonMarker());
      },
      buttonBuilder: (BuildContext context,
          ValueNotifier<LocationServiceStatus> status, Function onPressed) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: ValueListenableBuilder<LocationServiceStatus>(
                valueListenable: status,
                builder: (BuildContext context, LocationServiceStatus value,
                    Widget child) {
                  return Commons.locationState(value);
                },
              ),
              onPressed: () => onPressed(),
            ),
          ),
        );
      },
    );
  }
}
