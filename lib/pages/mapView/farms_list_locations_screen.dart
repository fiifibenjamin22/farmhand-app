import 'package:farmhand/pages/mapView/extensions/ListPaddockLocationsExt.dart';
import 'package:farmhand/pages/mapView/locaions_row_item.dart';
import 'package:farmhand/pages/farmsMapViewTaskPaddock.dart';
import 'package:farmhand/pages/storage/storage_locations.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPaddockLocations extends StatefulWidget {
  final includeStorageLocations;
  final bool leadingChoice;

  const ListPaddockLocations({
    Key key,
    this.includeStorageLocations,
    this.leadingChoice = true,
  }) : super(key: key);

  @override
  ListPaddockLocationsState createState() => ListPaddockLocationsState();
}

class ListPaddockLocationsState extends State<ListPaddockLocations> {
  List allOrganisationList;
  String screenTitle = "";
  double screenHeight;
  SharedPreferences preferences;
  bool isLoading = true;

  List<String> locationName = [];
  List<String> storageLocationsList = [];
  List<int> mapIdList = [];
  List<String> locationType = [];

  @override
  void initState() {
    super.initState();

    loadAllLocationsData();

    print("ALL LOCATION INIT IS CALLED..!!");
    screenTitle =
        widget.includeStorageLocations ? "All Locations" : "All Farms";
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return CommonDashScaffold(
      leadingback: widget.leadingChoice,
      pageTitle: screenTitle,
      child: Container(
        padding: EdgeInsets.only(top: 25),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Column(
                children: [
                  Container(
                    height: (screenHeight * 75) / 100,
                    child: ListView.builder(
                      itemCount: locationName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            int locationIndex = 0;
                            bool isStorageLocation =
                                locationType[index].contains("storage");
                            if (isStorageLocation) {
                              locationIndex = storageLocationsList
                                  .indexOf(locationName[index]);
                            }
                            isStorageLocation
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StorageLocationsScreen(
                                        initalIndex: locationIndex,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapViewTask(
                                        mapIdGet: mapIdList[index],
                                      ),
                                    ),
                                  );
                          },
                          child: LocationsRowItem(
                            locationName: locationName[index],
                            locationType: locationType[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
