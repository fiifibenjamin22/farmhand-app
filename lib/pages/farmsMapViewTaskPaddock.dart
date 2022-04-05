import 'package:connectivity/connectivity.dart';
import 'package:farmhand/pages/extensions/MapViewTaskExt.dart';
import 'package:farmhand/pages/taskPage/extensions/farmsMapViewTaskStateExtension.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:geodesy/geodesy.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapViewTask extends StatefulWidget {
  final mapIdGet;
  final bool changeMethod;
  final changeMethodPolygon;
  final List paddockNameList;
  final List paddockAllottedTaskList;
  final paddockworktasklabelList;

  MapViewTask({
    this.mapIdGet,
    this.changeMethod = false,
    this.changeMethodPolygon,
    this.paddockworktasklabelList,
    this.paddockNameList,
    this.paddockAllottedTaskList,
  });

  @override
  MapViewTaskState createState() => MapViewTaskState();
}

class MapViewTaskState extends State<MapViewTask> with WidgetsBindingObserver {
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
  bool searchPaddockColorChangebool = true;
  List searchResult = [];
  bool searchSelectionORnormal = true;
  Polygon selectedPolygon;
  bool mapgenerate = true;
  String systemLocation;
  List<LatLng> selectedLatLngValue;
  int selectedIndex = -1;
  bool foundSearchedPaddock = false;
  LatLng currentPoint;
  SharedPreferences preferences;
  int pastSelectIndex = -1;
  bool changeColor = false;
  bool paddockTapped = false;
  var toAdd = <Polygon>[];
  var toRemove = <Polygon>[];
  double zoomLevel = 0.0;
  double minZoomLevel = 0.0;
  double zoomLevelCheck = 0.0;
  TextEditingController searchController = TextEditingController();
  var isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    print("Farms MapViewTaskPaddock::::---->initState");
    loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) {
        _onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      _onKeyboardChanged(true);
    }
  }

  _onKeyboardChanged(bool isVisible) {
    if (isVisible) {
      print("KEYBOARD VISIBLE");
    } else {
      print("KEYBOARD HIDDEN");
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection();

    determinePosition().then((value) {
      if (mounted) {
        setState(() {
          currentPoint = LatLng(value.latitude, value.longitude);
        });
      }
    });

    livemap = liveLocation();

    var worktaskDataProvider = Provider.of<WorkTaskDataProvider>(context);
    workTaskID = worktaskDataProvider.worktaskID;
    if (widget.changeMethod) {
      checkpaddockCompleted(workTaskID);
    }
    return CommonDashScaffold(
      bottomimage: false,
      leadingback: false,
      bottomNavigationSheetin: makeChange
          ? SizedBox.shrink()
          : widget.changeMethod
              ? SizedBox.shrink()
              : Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      setAsGrazedFn(polygons.last);
                    },
                    child: Text("Set as Grazed"),
                  ),
                ),
      pageTitle: formNameget != null ? formNameget : "Loading...",
      child: FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          return makeABoundsIn != null
              ? Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        bounds: makeABoundsIn,
                        boundsOptions: FitBoundsOptions(
                          padding: EdgeInsets.all(20),
                        ),
                        interactiveFlags: checkInternet
                            ? InteractiveFlag.all & ~InteractiveFlag.rotate
                            : InteractiveFlag.none & ~InteractiveFlag.none,
                        allowPanning: checkInternet ? true : false,
                        plugins: [
                          LocationPlugin(),
                        ],
                        onTap: (point) => {
                          FocusScope.of(context).unfocus(),
                          changePaddockColor(point, false),
                          setState(() {
                            minZoomLevel = 0.0;
                          })
                        },
                        minZoom: minZoomLevel,
                        zoom: zoomLevel, // <-- IPS
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
                                urlTemplate:
                                    systemLocation + '/{z}/{x}/{y}.png',
                              ),
                        PolygonLayerOptions(
                          polygons: polygons,
                        ),
                        MarkerLayerOptions(markers: allMarkers),
                        livemap,
                      ],
                    ),
                    widget.changeMethod
                        ? SizedBox.shrink()
                        : Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: searchController,
                                    // focusNode: searchFocus,
                                    onFieldSubmitted: (value) {
                                      onSelectingSearchResult(0);
                                    },
                                    textInputAction: TextInputAction.go,
                                    onChanged: textSearchBoxFn,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 1, 20, 1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () => onSelectingSearchResult(0),
                                        child: Icon(Icons.search),
                                      ),
                                      hintText: "Search paddock...",
                                    ),
                                  ),
                                  Container(
                                    height: searchResult.length * 35.toDouble(),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          searchResult.length,
                                          (index) => GestureDetector(
                                            onTap: () {
                                              if (mounted) {
                                                print(
                                                    "search results selected:::::${searchController.text}");
                                                onSelectingSearchResult(
                                                    searchController.text);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: index == 0
                                                    ? Colors.green
                                                    : Colors.transparent,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              child: Align(
                                                child: Text(
                                                  searchResult[index],
                                                  style: TextStyle(
                                                    color: index == 0
                                                        ? Colors.white
                                                        : Colors.green,
                                                  ),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
        },
      ),
    );
  }
}
