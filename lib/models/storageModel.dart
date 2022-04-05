class StorageModel {
  int id;
  int organisationId;
  String name;
  String description;
  double latitude;
  double longitude;
  String createdBy;
  String createdById;
  String createdDateTime;
  String modifiedById;
  String modifiedDateTime;
  List<InventoryItems> inventoryItems;

  StorageModel(
      {this.id,
      this.organisationId,
      this.name,
      this.description,
      this.latitude,
      this.longitude,
      this.createdBy,
      this.createdById,
      this.createdDateTime,
      this.modifiedById,
      this.modifiedDateTime,
      this.inventoryItems});

  StorageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organisationId = json['organisationId'];
    name = json['name'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdBy = json['createdBy'];
    createdById = json['createdById'];
    createdDateTime = json['createdDateTime'];
    modifiedById = json['modifiedById'];
    modifiedDateTime = json['modifiedDateTime'];
    if (json['inventoryItems'] != null) {
      inventoryItems = <InventoryItems>[];
      json['inventoryItems'].forEach((v) {
        inventoryItems.add(new InventoryItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organisationId'] = this.organisationId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdBy'] = this.createdBy;
    data['createdById'] = this.createdById;
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedById'] = this.modifiedById;
    data['modifiedDateTime'] = this.modifiedDateTime;
    if (this.inventoryItems != null) {
      data['inventoryItems'] =
          this.inventoryItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InventoryItems {
  int id;
  int inventoryItemId;
  int storageLocationId;
  int level;
  String effectiveDateTime;
  InventoryItem inventoryItem;

  InventoryItems(
      {this.id,
      this.inventoryItemId,
      this.storageLocationId,
      this.level,
      this.effectiveDateTime,
      this.inventoryItem});

  InventoryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inventoryItemId = json['inventoryItemId'];
    storageLocationId = json['storageLocationId'];
    level = json['level'];
    effectiveDateTime = json['effectiveDateTime'];
    inventoryItem = json['inventoryItem'] != null
        ? new InventoryItem.fromJson(json['inventoryItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['inventoryItemId'] = this.inventoryItemId;
    data['storageLocationId'] = this.storageLocationId;
    data['level'] = this.level;
    data['effectiveDateTime'] = this.effectiveDateTime;
    if (this.inventoryItem != null) {
      data['inventoryItem'] = this.inventoryItem.toJson();
    }
    return data;
  }
}

class InventoryItem {
  int id;
  int organisationId;
  int inventoryTypeId;
  String name;
  String description;
  double unitPrice;
  int reorderLevel;
  int reorderQuantity;

  InventoryItem(
      {this.id,
      this.organisationId,
      this.inventoryTypeId,
      this.name,
      this.description,
      this.unitPrice,
      this.reorderLevel,
      this.reorderQuantity});

  InventoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organisationId = json['organisationId'];
    inventoryTypeId = json['inventoryTypeId'];
    name = json['name'];
    description = json['description'];
    unitPrice = json['unitPrice'];
    reorderLevel = json['reorderLevel'];
    reorderQuantity = json['reorderQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organisationId'] = this.organisationId;
    data['inventoryTypeId'] = this.inventoryTypeId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['unitPrice'] = this.unitPrice;
    data['reorderLevel'] = this.reorderLevel;
    data['reorderQuantity'] = this.reorderQuantity;
    return data;
  }
}
