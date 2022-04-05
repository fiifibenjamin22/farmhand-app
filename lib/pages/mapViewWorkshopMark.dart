import 'package:farmhand/pages/extensions/MapViewWorkShopExt.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:geodesy/geodesy.dart';
import 'package:latlong/latlong.dart';
import '../constant.dart';

class MapViewWorkShop extends StatefulWidget {
  final mapIdGet;
  MapViewWorkShop({this.mapIdGet});
  @override
  MapViewWorkShopState createState() => MapViewWorkShopState();
}

class MapViewWorkShopState extends State<MapViewWorkShop> {
  List<LatLng> workinLatLng = [];
  List initialWorkList;
  LocationOptions userLocationOptions;
  LatLngBounds makeABoundsIn;

  LatLng dummypoint;
  Polygon currentPolygon;

  MapController mapController = MapController();
  List<Marker> markers = [];
  final polygons = <Polygon>[];

  @override
  void initState() {
    super.initState();
    allAPIofFarmHand
        .mapWorktask(widget.mapIdGet)
        .then((value) => processData(value));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDashScaffold(
      bottomimage: false,
      leadingback: false,
      pageTitle: "Farm Location",
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          bounds: makeABoundsIn,
          boundsOptions: FitBoundsOptions(),
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          plugins: [
            // TappablePolylineMapPlugin(),
            LocationPlugin(),
          ],
          // zoom: 1.8,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: markers),
          userLocationOptions,
        ],
      ),
    );
  }
}
