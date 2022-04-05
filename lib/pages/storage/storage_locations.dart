import 'dart:async';
import 'package:farmhand/models/organisation.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/pages/storage/extensions/StorageLocationsScreenExt.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/material.dart';

class StorageLocationsScreen extends StatefulWidget {
  final int initalIndex;

  const StorageLocationsScreen({
    Key key,
    this.initalIndex,
  }) : super(key: key);

  @override
  StorageLocationsState createState() => StorageLocationsState();
}

class StorageLocationsState extends State<StorageLocationsScreen> {
  Future storageData;
  int count;
  PageController pageController;
  ValueNotifier currentPageNotifier;
  bool isLoading = true;
  List<StorageLocations> storageLocationsList = [];
  List<Organisation> organisationDetails = [];
  int locationsCount = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initalIndex);
    currentPageNotifier = ValueNotifier<int>(widget.initalIndex);
    loadStorageLocationsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: CommonDashScaffold(
        pageTitle: "STORAGE",
        child: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            : locationsCount == 0
                ? Center(
                    child: Text("No storage location"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildStepIndicator(),
                      buildPageView(storageLocationsList, organisationDetails)
                    ],
                  ),
      ),
    );
  }
}
