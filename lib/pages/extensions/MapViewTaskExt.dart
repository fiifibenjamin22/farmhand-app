import 'package:farmhand/pages/farmsMapViewTaskPaddock.dart';
import 'package:farmhand/pages/taskPage/extensions/farmsMapViewTaskStateExtension.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:toast/toast.dart';

extension MapViewTaskExt on MapViewTaskState {
  LocationOptions liveLocation() {
    return LocationOptions(
      markers: allMarkers,
      onLocationUpdate: (LatLngData ld) {
        // print('Location updated: ${ld?.location}');
      },
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
                      : Icon(
                          Icons.visibility_off,
                        ),
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
}
