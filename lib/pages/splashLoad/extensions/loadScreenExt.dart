import 'dart:io';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/noInternet.dart';
import 'package:farmhand/pages/splashLoad/load_screenData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension LoadScreenDataExt on LoadScreenDataState {
  loadAllApi() async {
    preferences = await SharedPreferences.getInstance();
    try {
      allAPIofFarmHand.dashWorktaskA().whenComplete(() {
        // ignore: invalid_use_of_protected_member
        setState(() {
          loadvalueGet = 0.1;
        });
        allAPIofFarmHand.dashWorktaskB().whenComplete(() {
          // ignore: invalid_use_of_protected_member
          setState(() {
            loadvalueGet = 0.3;
          });
          allAPIofFarmHand.mapAllWorktask().whenComplete(() {
            // ignore: invalid_use_of_protected_member
            setState(() {
              loadvalueGet = 0.6;
            });
            allAPIofFarmHand.mapForAllOrganisation().whenComplete(() {
              // ignore: invalid_use_of_protected_member
              setState(() {
                loadvalueGet = 0.8;
              });
              allAPIofFarmHand.storageFarm().whenComplete(() {
                // ignore: invalid_use_of_protected_member
                setState(() {
                  String storageJson = preferences
                      .getString(SharedOfflineData().storageLocationContent);
                  if (storageJson != null) {
                    if (storageJson.isNotEmpty) {
                      allAPIofFarmHand
                          .postStorageLocationItemLevel(storageJson);
                    }
                  }
                  loadvalueGet = 1.0;
                });
              });
            });
          });
        });
      });
    } on SocketException catch (_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoInternetPage()),
          (route) => false);
    } on FormatException catch (_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NoInternetPage()),
          (route) => false);
    } catch (e) {
      throw Exception(e);
    }
  }
}
