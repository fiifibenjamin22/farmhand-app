import 'dart:convert';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/storage/StorageCardB.dart';
import 'package:farmhand/pages/storage/storage_locations.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';

extension StorageCardBExt on StorageCardBState {
  storeValueInPreferences(
      int storageLocationPosition, int inventoryItemIndex, int currentLevel) {
    DateTime dateTime = DateTime.now();
    // ignore: invalid_use_of_protected_member
    setState(() {
      isValueChanged = false;
    });
    var storageLocationContent = jsonEncode({
      "currentLevel": currentLevel,
      "effectiveDateTime": dateTime.toString(),
      "itemId": widget.inventoryItems.inventoryItemId,
      "storageLocationId": widget.inventoryItems.storageLocationId,
    });
    Utils.setStringToPreferences(
        SharedOfflineData().storageLocationContent, storageLocationContent);

    String storageLocations =
        Utils.getStringFromPreferences(SharedOfflineData().storageLocations);
    List<dynamic> storageLocationsList = jsonDecode(storageLocations);

    storageLocationsList[storageLocationPosition]['inventoryItems']
        [inventoryItemIndex]['level'] = currentLevel;
    allAPIofFarmHand
        .postStorageLocationItemLevel(storageLocationContent)
        .whenComplete(
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StorageLocationsScreen(
                initalIndex: storageLocationPosition,
              ),
            ),
          ),
        );
  }
}
