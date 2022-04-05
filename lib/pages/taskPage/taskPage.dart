import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:farmhand/pages/ShowTaskInMapView.dart';
import 'package:farmhand/pages/taskPage/extensions/taskProcessData.dart';
import 'package:farmhand/pages/taskPage/finishedTaskPage.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/utils/api_helper.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:geodesy/geodesy.dart';
import 'package:farmhand/pages/taskPage/taskNoteC.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'taskCardA.dart';
import 'taskpaddockB.dart';
import 'package:latlong/latlong.dart';

class TaskPageIN extends StatefulWidget {
  final selectedIndex;
  final getMapData;
  final liveformLocation;
  final orgName;
  TaskPageIN(
      {this.selectedIndex,
      this.getMapData,
      this.liveformLocation,
      this.orgName});
  @override
  TaskPageINState createState() => TaskPageINState();
}

class TaskPageINState extends State<TaskPageIN> {
  final polygons = <Polygon>[];
  List<LatLng> workinLatLng = [];
  LatLngBounds makeABoundsIn;
  MapController mapController = MapController();
  Geodesy geodesy = Geodesy();
  bool makeChange = true;
  List<Marker> paddockLabelMarkesList = [];
  bool paddockLabelVisiblity = true;
  List<LatLng> geopoint = [];
  List<LatLng> polygonLastData;
  List paddockNames = [];
  List paddockTaskAllottedList = [];
  SingleWorkTask workTaskSingleData = SingleWorkTask();
  SharedPreferences preference;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("TASK PAGE INIT CALLED..!!");

    int mapId = widget.getMapData[widget.selectedIndex]['mapId'];
    print("MAP ID IS $mapId");
    ApiHelper.getApiService().getMapGeoLocationDetails(mapId);

    loadData().then((value) => isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading && workTaskSingleData != null) {
      var worktaskDataProvider = Provider.of<WorkTaskDataProvider>(context);
      worktaskDataProvider.workTaskSingleData = workTaskSingleData;
      worktaskDataProvider.worktaskID = workTaskSingleData.id.toString();
      worktaskDataProvider.paddockNames = paddockNames;
      double sizeSpaceEqual = 10.0;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CommonDashScaffold(
          leadingback: false,
          floatingActionButtonLocationin:
              FloatingActionButtonLocation.centerDocked,
          pageTitle: widget.getMapData[widget.selectedIndex]['name'],
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10,
                MediaQuery.of(context).viewInsets.bottom == 0.0 ? 90 : 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CardA(
                    getpolygondata: polygons,
                    getworkTaskSingleData: workTaskSingleData,
                    paddockMarkerlabelList: paddockLabelMarkesList,
                    paddockNameListget: paddockNames,
                    liveformloaction: widget.liveformLocation,
                    mapidgetin: widget.getMapData[widget.selectedIndex]
                            ['worktaskapplication']['applicationProduct']
                        ['inventoryItem']['organisationId'],
                  ),
                  SizedBox(
                    height: sizeSpaceEqual + 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(sizeSpaceEqual + 10, 0, 0, 0),
                          child: Text(
                            "PADDOCKS",
                            style: TextStyle(
                                color: Color(0xFF336BAB),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      makeChange
                          ? Text("Loading...")
                          : (polygons.isNotEmpty
                              ? CardB(
                                  paddocksRelatedToTaskList:
                                      paddockTaskAllottedList,
                                  polygonData: polygons,
                                  paddockNameList: paddockNames,
                                )
                              : Text("No paddocks")),
                    ],
                  ),
                  SizedBox(
                    height: sizeSpaceEqual + 20,
                  ),
                  CardC(),
                  SizedBox(
                    height: sizeSpaceEqual * 5,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonin: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 35),
                child: polygons.isNotEmpty
                    ? WorkTaskFinish()
                    : ElevatedButton(
                        onPressed: null,
                        child: Text("Finish"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ),
              InkWell(
                child: SvgPicture.asset(
                  "assets/loc_button.svg",
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  if (polygons.isEmpty) {
                    showToast(
                      "No paddocks to Show",
                      context,
                      durationIN: 3,
                      gravityIN: Toast.BOTTOM,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskInMapView(
                          // changeMethod: true,
                          changeMethodPolygon: polygons,
                          paddockAllottedTaskList: paddockTaskAllottedList,
                          paddockworktasklabelList: paddockLabelMarkesList,
                          paddockNameList: paddockNames,
                          mapIdGet: widget.getMapData[widget.selectedIndex]
                                  ['worktaskapplication']['applicationProduct']
                              ['inventoryItem']['organisationId'],
                          taskName: widget.getMapData[widget.selectedIndex]
                              ['name'],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return CommonDashScaffold(
        pageTitle: "Loading...",
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      );
    }
  }
}
