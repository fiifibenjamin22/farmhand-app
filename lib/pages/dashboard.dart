import 'dart:async';

import 'package:farmhand/pages/taskPage/Cards/DashCardA.dart';
import 'package:farmhand/pages/taskPage/Cards/DashCardB.dart';
import 'package:farmhand/pages/taskPage/extensions/dashboardExtension.dart';
import 'package:farmhand/widgets/common_dashboard_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mapView/farms_list_locations_screen.dart';

class FormHandDashboard extends StatefulWidget {
  @override
  FormHandDashboardState createState() => FormHandDashboardState();
}

class FormHandDashboardState extends State<FormHandDashboard>
    with WidgetsBindingObserver {
  Future dashboardDataA;
  Future dashboardDataB;
  SharedPreferences preferences;
  List organisationNewForm = [];
  List taskDataGetInstant = [];
  var taskLengthCreated = 0;
  bool flagToCount = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("resumed");
    }

    if (state == AppLifecycleState.inactive) {
      print("inactive");
    }

    if (state == AppLifecycleState.paused) {
      print("paused");
    }

    if (state == AppLifecycleState.detached) {
      print("detached");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: CommonDashScaffold(
        pageTitle: "DASHBOARD",
        // This is was commented out as this locations page is not being used at this time.
        // floatingActionButtonin: InkWell(
        //   child: SvgPicture.asset(
        //     "assets/loc_button.svg",
        //     fit: BoxFit.cover,
        //   ),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ListPaddockLocations(
        //           includeStorageLocations: true,
        //           leadingChoice: false,
        //         ),
        //       ),
        //     );
        //   },
        // ),
        child: !isLoading && organisationNewForm.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: InkWell(
                          child: DashCardA(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPaddockLocations(
                                  leadingChoice: false,
                                  includeStorageLocations: false,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "MY TASKS",
                            style: TextStyle(
                                color: Color.fromRGBO(51, 107, 171, 1),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.grey,
                            child: Text(
                              "$taskLengthCreated",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      DashCardB(
                        taskDataGet: taskDataGetInstant,
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
      ),
    );
  }
}
