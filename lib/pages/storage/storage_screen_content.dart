import 'package:farmhand/models/organisation.dart';
import 'package:farmhand/models/storage_locations/inventory_item_element.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/pages/storage/StorageCardB.dart';
import 'package:farmhand/pages/storage/storagePage.dart';
import 'package:flutter/material.dart';

class StorageLocationsContent extends StatefulWidget {
  final int storageLocationPosition;
  final StorageLocations storageDatain;
  final Organisation organisationDetails;
  final List<InventoryItemElement> inventoryItems;

  StorageLocationsContent({
    this.storageLocationPosition,
    this.storageDatain,
    this.organisationDetails,
    this.inventoryItems,
  });

  @override
  _StorageLocationsContentState createState() =>
      _StorageLocationsContentState();
}

class _StorageLocationsContentState extends State<StorageLocationsContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StorageCardA(
            organisationDetails: widget.organisationDetails,
            storageDatain: widget.storageDatain,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              children: List.generate(
                widget.inventoryItems.length,
                (inventoryItemsIndex) => StorageCardB(
                  storageLocationPosition: widget.storageLocationPosition,
                  getindex: inventoryItemsIndex,
                  inventoryItems: widget.inventoryItems[inventoryItemsIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
