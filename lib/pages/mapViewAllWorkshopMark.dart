import 'package:farmhand/pages/extensions/mapeViewAllWorkshopExt.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:farmhand/widgets/reusables/Commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:geodesy/geodesy.dart';
import 'package:latlong/latlong.dart';
import '../constant.dart';

class MapViewAllWorkShop extends StatefulWidget {
  final mapIdGet;
  final bool getStorageLocation;
  final bool leadingBack;
  MapViewAllWorkShop(
      {this.mapIdGet,
      this.getStorageLocation = false,
      this.leadingBack = false});
  @override
  MapViewAllWorkShopState createState() => MapViewAllWorkShopState();
}

class MapViewAllWorkShopState extends State<MapViewAllWorkShop> {
  final polygons = <Polygon>[];
  List<LatLng> geopoint = [];
  Geodesy geodesy = Geodesy();
  List<LatLng> dummypoint = [];
  LatLngBounds makeABoundsIn;
  bool checkmarker = true;
  bool flagforlivedelay = false;
  bool storageLoctaioncCheck;
  List<Marker> buttonMarker = [];
  List<Marker> storageMarker = [];
  List<Marker> liveMarkerList = [];
  LocationOptions liveMap;
  MapController mapController = MapController();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    allAPIofFarmHand.mapAllWorktask().then((value) => processData(value));
    storageLoctaioncCheck = widget.getStorageLocation;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    liveMap = LocationOptions(
      markers: liveMarkerList,
      onLocationUpdate: (LatLngData ld) {},
      onLocationRequested: (LatLngData ld) {
        longLatData(ld);
      },
      buttonBuilder: (BuildContext context,
          ValueNotifier<LocationServiceStatus> status, Function onPressed) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.getStorageLocation
                    ? FloatingActionButton(
                        heroTag: "buttonStore",
                        backgroundColor: storageLoctaioncCheck
                            ? Color(0xfff5c43d)
                            : Colors.white,
                        mini: true,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset("assets/workshopIcon.png"),
                        ),
                        onPressed: () {
                          setState(() {
                            addRemoveMarker();
                          });
                        },
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  heroTag: "livelocation",
                  backgroundColor: Colors.blue,
                  child: ValueListenableBuilder<LocationServiceStatus>(
                      valueListenable: status,
                      builder: (BuildContext context,
                          LocationServiceStatus value, Widget child) {
                        return Commons.locationState(value);
                      }),
                  onPressed: () => onPressed(),
                ),
              ],
            ),
          ),
        );
      },
    );
    return CommonDashScaffold(
      bottomimage: false,
      leadingback: widget.leadingBack,
      pageTitle: widget.getStorageLocation ? "Maps" : "Farm Locations",
      child: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          if (dummypoint.isNotEmpty) {
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                bounds: makeABoundsIn,
                boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(20)),
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                plugins: [
                  LocationPlugin(),
                ],
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(markers: markers, rebuild: null),
                liveMap
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
