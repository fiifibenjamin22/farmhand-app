import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/login.dart';
import 'package:farmhand/pages/menu.dart';
import 'package:farmhand/services/imageUploadWorkTask.dart';
import 'package:farmhand/utils/common_utils.dart';

import 'package:farmhand/widgets/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';

import 'common_progressIndicator.dart';
import 'common_showConfirmAlert.dart';
import 'common_toast.dart';

class CommonDashScaffold extends StatefulWidget {
  final Widget child;
  final Widget floatingActionButtonin;
  final Widget bottomNavigationBarin;
  final Widget bottomNavigationSheetin;
  final FloatingActionButtonLocation floatingActionButtonLocationin;
  final String pageTitle;
  final bool bottomimage;
  final bool leadingback;
  CommonDashScaffold(
      {this.child,
      this.floatingActionButtonin,
      @required this.pageTitle,
      this.bottomimage = true,
      this.bottomNavigationBarin,
      this.leadingback = true,
      this.bottomNavigationSheetin,
      this.floatingActionButtonLocationin =
          FloatingActionButtonLocation.endDocked,
      Key key})
      : super(key: key);
  @override
  _CommonDashScaffoldState createState() => _CommonDashScaffoldState();
}

class _CommonDashScaffoldState extends State<CommonDashScaffold> {
  ConnectivityResult connectivityResult;
  void checkInternetConnection() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    final SharedPreferences prefs = await sharePrefs;
    bool jwtExp = prefs.getString("jwtToken") != null
        ? JwtDecoder.isExpired(prefs.getString("jwtToken"))
        : true;
    if (connectivityResult == ConnectivityResult.none && internetCheck) {
      showToast("No Internet Connection", context,
          durationIN: 3, gravityIN: Toast.BOTTOM);
      setState(() {
        internetCheck = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        internetCheck = true;
      });
//<------------- offlineStore Set as grazed setup--------------->
      String offlineStoreSetAsGrazedString = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreSetAsGrazed}");
      List offlineStoreSetAsGrazedList =
          offlineStoreSetAsGrazedString.isNotEmpty
              ? json.decode(offlineStoreSetAsGrazedString)
              : [];
      if (offlineStoreSetAsGrazedList.isNotEmpty) {
        print(
            "offlineStoreSetAsGrazedList ${offlineStoreSetAsGrazedList.length}");
        Future.forEach(
                offlineStoreSetAsGrazedList,
                (offlineStoreSetAsGrazedListelement) => allAPIofFarmHand
                    .paddocksGrazedAPI(offlineStoreSetAsGrazedListelement))
            .whenComplete(() {
          String makeEmpty = json.encode([]);
          Utils.setStringToPreferences(
              "${SharedOfflineData().offlineStoreSetAsGrazed}", makeEmpty);
          print("offlineStoreSetAsGrazedList completed");
        });
      }
//<-------------------------- end ------------------------------------->

//<------------- offlineStore completed paddock setup--------------->
      String offlineStoreCompletedPaddockTask = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreCompletedPaddockTask}");
      List offlineStoreCompletedPaddockTaskList =
          offlineStoreCompletedPaddockTask.isNotEmpty
              ? json.decode(offlineStoreCompletedPaddockTask)
              : [];
      if (offlineStoreCompletedPaddockTaskList.isNotEmpty) {
        print(
            "offlineStoreCompletedPaddockTaskList ${offlineStoreCompletedPaddockTaskList.length}");
        Future.forEach(offlineStoreCompletedPaddockTaskList,
            (offlineStoreCompletedPaddockTaskListelement) {
          allAPIofFarmHand.workTasksPutData(
              offlineStoreCompletedPaddockTaskListelement['worktaskidgot'],
              offlineStoreCompletedPaddockTaskListelement['worktaskcomplete']);
        }).whenComplete(() {
          String makeEmpty = json.encode([]);
          Utils.setStringToPreferences(
              "${SharedOfflineData().offlineStoreCompletedPaddockTask}",
              makeEmpty);
          print("offlineStoreCompletedPaddockTaskList completed");
        });
      }
//<-------------------------- end ------------------------------------->

//<------------- offlineStore Storage Location setup--------------->
      String offlineStoreStorageLocationString = Utils.getStringFromPreferences(
          "${SharedOfflineData().offlineStoreStorageLocation}");
      List offlineStoreStorageLocationList =
          offlineStoreStorageLocationString.isNotEmpty
              ? json.decode(offlineStoreStorageLocationString)
              : [];
      if (offlineStoreStorageLocationList.isNotEmpty) {
        print(
            "offlineStoreStorageLocationList ${offlineStoreStorageLocationList.length}");
        Future.forEach(offlineStoreStorageLocationList,
            (offlineStoreStorageLocationListelement) {
          allAPIofFarmHand.postStorageLocationItemLevel(
              offlineStoreStorageLocationListelement);
        }).whenComplete(() {
          String makeEmpty = json.encode([]);
          Utils.setStringToPreferences(
              "${SharedOfflineData().offlineStoreStorageLocation}", makeEmpty);
          print("offlineStoreStorageLocationList completed");
        });
      }
//<-------------------------- end ------------------------------------->

//<------------- offlineStore Worktask Image upload setup--------------->

      String offlineStoreWorkTaskImageFileLocalDecode =
          Utils.getStringFromPreferences(
              "${SharedOfflineData().workTaskImageFileLocal}");
      List offlineStoreWorkTaskImageFileLocalList =
          offlineStoreWorkTaskImageFileLocalDecode.isNotEmpty
              ? json.decode(offlineStoreWorkTaskImageFileLocalDecode)
              : [];
      String offlineStoreWorkTaskImageFileUploadedDecode =
          Utils.getStringFromPreferences(
              "${SharedOfflineData().workTaskImageFileUploaded}");
      List offlineStoreWorkTaskImageFileUploadedList =
          offlineStoreWorkTaskImageFileUploadedDecode.isNotEmpty
              ? json.decode(offlineStoreWorkTaskImageFileUploadedDecode)
              : [];
      if (offlineStoreWorkTaskImageFileLocalList.isNotEmpty) {
        if (!jwtExp) {
          print(
              "offlineStoreWorkTaskImageFileLocalList ${offlineStoreWorkTaskImageFileLocalList.length}");
          Future.forEach(offlineStoreWorkTaskImageFileLocalList,
              (offlineStoreWorkTaskImageFileLocalListelement) {
            List<File> generateImageFile = [];
            for (var workImageFileItem
                in offlineStoreWorkTaskImageFileLocalListelement[
                    'workTaskImageFileLocal']) {
              generateImageFile.add(File(workImageFileItem));
            }
            workTaskImageUpload(
                    generateImageFile,
                    int.parse(offlineStoreWorkTaskImageFileLocalListelement[
                        'workID']))
                .whenComplete(() {
              Map localimageNotebyWorkid = {
                'workID':
                    offlineStoreWorkTaskImageFileLocalListelement['workID'],
                'workTaskImageFileLocal':
                    offlineStoreWorkTaskImageFileLocalListelement[
                        'workTaskImageFileLocal']
              };
              if (offlineStoreWorkTaskImageFileUploadedList.isNotEmpty) {
                bool checkImageIN = false;
                for (var checkImageFileUploadedListItem
                    in offlineStoreWorkTaskImageFileUploadedList) {
                  if (checkImageFileUploadedListItem['workID'] ==
                      offlineStoreWorkTaskImageFileLocalListelement['workID']) {
                    List alreadyUploaded = checkImageFileUploadedListItem[
                        'workTaskImageFileLocal'];
                    for (var localImageitem
                        in offlineStoreWorkTaskImageFileLocalListelement[
                            'workTaskImageFileLocal']) {
                      alreadyUploaded.add(localImageitem);
                    }
                    checkImageIN = true;
                  }
                }
                if (!checkImageIN) {
                  offlineStoreWorkTaskImageFileUploadedList
                      .add(localimageNotebyWorkid);
                }
              } else {
                offlineStoreWorkTaskImageFileUploadedList
                    .add(localimageNotebyWorkid);
              }
              String makeuploadFull =
                  json.encode(offlineStoreWorkTaskImageFileUploadedList);
              Utils.setStringToPreferences(
                  "${SharedOfflineData().workTaskImageFileUploaded}",
                  makeuploadFull);
              String makeEmpty = json.encode([]);
              Utils.setStringToPreferences(
                  "${SharedOfflineData().workTaskImageFileLocal}", makeEmpty);
              print("offlineStoreWorkTaskImageFileLocalList completed");
            });
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      checkInternetConnection();
    });
    return CommonScaffold(
      floatingActionButtonLocation: widget.floatingActionButtonLocationin,
      bottomNavigationSheetin: widget.bottomNavigationSheetin,
      floatingActionButtonin: widget.floatingActionButtonin,
      bottomNavigationBarin: widget.bottomNavigationBarin,
      appBarin: PreferredSize(
          child: AppBar(
            leading: widget.leadingback
                ? IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      showdialogFormMenu(context);
                    })
                : IconButton(
                    icon: Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
            centerTitle: false,
            title: FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Flexible(child: Text(widget.pageTitle))],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showConfirmationDialog(
                      context,
                      'Are you sure you want to logout?',
                      () {
                        Navigator.pop(context);
                        ProgIndicator(context);
                        allAPIofFarmHand.userOutAuthenticate().then((value) {
                          if (value[0]) {
                            Navigator.pop(context);
                            showToast("Logout Successful", context,
                                durationIN: 3, gravityIN: Toast.BOTTOM);
                            Future.delayed(
                              Duration(seconds: 2),
                              () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormLogin(),
                                  ),
                                  (route) => false),
                            );
                          } else {
                            Navigator.pop(context);
                            showToast(value[1], context,
                                durationIN: 3, gravityIN: Toast.BOTTOM);
                          }
                        });
                      },
                      false,
                    );
                  },
                  child: Icon(Icons.logout),
                ),
              )
            ],
          ),
          preferredSize: Size.fromHeight(50)),
      bodyin: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
                padding: EdgeInsets.all(widget.bottomimage ? 10.0 : 0.0),
                child: widget.child),
          ),
          widget.bottomimage
              ? Positioned(
                  bottom: 0,
                  child: SvgPicture.asset("assets/dashboard.svg"),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
