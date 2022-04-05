import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/models/organisation.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/pages/storage/storage_locations.dart';
import 'package:farmhand/pages/storage/storage_screen_content.dart';
import 'package:farmhand/utils/api_helper.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

extension StorageLocationsScreenExt on StorageLocationsState {
  loadStorageLocationsData() async {
    storageLocationsList =
        await ApiHelper.getApiService().getAllStorageLocations();

    if (storageLocationsList != null && storageLocationsList.length > 0) {
      locationsCount = storageLocationsList.length;
      Map personDetailsMap = jsonDecode(
          Utils.getStringFromPreferences(SharedOfflineData().personDetails));

      PersonDetails personDetails = PersonDetails.fromJson(personDetailsMap);

      organisationDetails = personDetails.organisations;
    }
    // ignore: invalid_use_of_protected_member
    setState(() {
      isLoading = false;
    });
  }

  buildPageView(
    List<StorageLocations> _storageLocationsList,
    List<Organisation> organisationDetails,
  ) {
    return Expanded(
      child: PageView.builder(
        itemBuilder: (context, position) {
          print("position::$position");
          return StorageLocationsContent(
            storageLocationPosition: position,
            organisationDetails: organisationDetails[0],
            storageDatain: _storageLocationsList[position],
            inventoryItems: _storageLocationsList[position].inventoryItems,
          );
        },
        itemCount: locationsCount,
        controller: pageController,
        onPageChanged: (int index) {
          currentPageNotifier.value = index;
        },
      ),
    );
  }

  buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: StepPageIndicator(
        itemCount: locationsCount,
        currentPageNotifier: currentPageNotifier,
        size: 16,
        onPageSelected: (int index) {
          pageController.animateToPage(index,
              duration: Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeIn);
        },
        previousStep: Container(
          child: Icon(
            Icons.radio_button_off_outlined,
            color: Colors.green,
            size: 20,
          ),
        ),
        selectedStep: Container(
          child: Icon(
            Icons.radio_button_on_outlined,
            color: Colors.green,
            size: 20,
          ),
        ),
        nextStep: Container(
          child: Icon(
            Icons.radio_button_off_outlined,
            color: Colors.green,
            size: 20,
          ),
        ),
      ),
    );
  }
}
