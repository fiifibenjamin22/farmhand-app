import 'package:farmhand/pages/MapDownloader/MapImageDownloaderExt.dart';
import 'package:farmhand/widgets/common_image_getLocal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapImageDownloader extends StatefulWidget {
  @override
  MapImageDownloaderState createState() => MapImageDownloaderState();
}

class MapImageDownloaderState extends State<MapImageDownloader> {
  SharedPreferences preferences;
  MapController mapController = MapController();
  LatLngBounds makeABoundsIn;
  String loadingMapName = "";
  List checkTheCount = [];

  void initState() {
    super.initState();
    loadData();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection();
    return Card(
      margin: EdgeInsets.zero,
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: true,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                bounds: makeABoundsIn,
                boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(20)),
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                onTap: (val) {},
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  tilesContainerBuilder: (context, widget, tile) {
                    checkInternetConnection();
                    if (tile.isNotEmpty) {
                      for (var tileItem in tile) {
                        if (tileItem.imageInfo != null)
                          SaveFile().saveImage(tileItem.imageInfo.debugLabel);
                      }
                    }
                    return widget;
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("$loadingMapName Map loading...")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
