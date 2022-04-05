import 'package:connectivity/connectivity.dart';
import 'package:farmhand/pages/taskPage/extensions/taskInMapExtension.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:geodesy/geodesy.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskInMapView extends StatefulWidget {
  final mapIdGet;
  final changeMethodPolygon;
  final List paddockNameList;
  final List paddockAllottedTaskList;
  final paddockworktasklabelList;
  final String taskName;

  TaskInMapView({
    this.mapIdGet,
    this.changeMethodPolygon,
    this.paddockworktasklabelList,
    this.paddockNameList,
    this.paddockAllottedTaskList,
    this.taskName,
  });

  @override
  TaskInMapViewState createState() => TaskInMapViewState();
}

class TaskInMapViewState extends State<TaskInMapView> {
  List<Polygon> polygons = [];
  List<LatLng> workinLatLng = [];
  List<Marker> paddockLabelMarkesList = [];
  bool paddockLabelVisiblity = true;
  String formNameget;
  Geodesy geodesy = Geodesy();
  LatLngBounds makeABoundsIn;
  List makePaddockchangeData = [];
  String workTaskID;
  bool makeChange = true;
  List<LatLng> polygonLastData;
  bool flagforlivedelay = false;
  bool completedPolyflag = true;
  MapController mapController = MapController();
  List<Marker> allMarkers = [];
  List<LatLng> geopoint = [];
  LocationOptions livemap;
  Marker workTaskmarkerEdit;
  Color junkColor;
  int localSaveCount;
  int completeSaveCount;
  ConnectivityResult connectivityResult;
  bool checkInternet = true;
  List paddockAllottedTaskid = [];
  Polygon selectedPolygon;
  bool mapgenerate = true;
  String systemLocation;
  List<LatLng> selectedLatLngValue;
  int selectedIndex = -1;
  bool loadBottomSheet = true;
  LatLng currentPoint;
  SharedPreferences preference;
  double zoomLevel = 0.0;

  int pastSelectIndex = -1;
  bool changeColor = false;
  bool paddockTapped = false;
  var toAdd = <Polygon>[];
  var toRemove = <Polygon>[];
  double minZoomLevel = 0.0;
  double zoomLevelCheck = 0.0;

  @override
  void initState() {
    super.initState();
    print("TaskInMapView::::---->initState");
    loadData();
  }

  @override
  void dispose() {
    zoomLevel = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection();

    var worktaskDataProvider = Provider.of<WorkTaskDataProvider>(context);
    workTaskID = worktaskDataProvider.worktaskID;

    checkpaddockCompleted(workTaskID);

    if (livemap == null) {
      buildLiveMap();
    }

    return CommonDashScaffold(
      bottomimage: false,
      leadingback: false,
      pageTitle: formNameget != null ? formNameget : "Loading...",
      child: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          if (makeABoundsIn != null) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    bounds: makeABoundsIn,
                    boundsOptions:
                        FitBoundsOptions(padding: EdgeInsets.all(20)),
                    interactiveFlags: checkInternet
                        ? InteractiveFlag.all & ~InteractiveFlag.rotate
                        : InteractiveFlag.none & ~InteractiveFlag.none,
                    allowPanning: checkInternet ? true : false,
                    plugins: [
                      LocationPlugin(),
                    ],
                    onTap: (point) => {
                      changePaddockColor(point),
                    },
                    minZoom: zoomLevel,
                    zoom: zoomLevel,
                  ),
                  layers: [
                    checkInternet
                        ? TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          )
                        : TileLayerOptions(
                            tileProvider: FileTileProvider(),
                            urlTemplate: systemLocation + '/{z}/{x}/{y}.png',
                          ),
                    PolygonLayerOptions(
                      polygons: polygons,
                    ),
                    MarkerLayerOptions(markers: allMarkers),
                    livemap,
                  ],
                ),
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
