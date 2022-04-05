import 'package:farmhand/models/storage_locations/inventory_item_element.dart';

class StorageLocations {
  StorageLocations({
    this.id,
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
    this.inventoryItems,
  });

  num id;
  num organisationId;
  String name;
  dynamic description;
  double latitude;
  double longitude;
  String createdBy;
  String createdById;
  DateTime createdDateTime;
  String modifiedById;
  DateTime modifiedDateTime;
  List<InventoryItemElement> inventoryItems;

  factory StorageLocations.fromJson(Map<String, dynamic> json) =>
      StorageLocations(
        id: json["id"],
        organisationId: json["organisationId"],
        name: json["name"],
        description: json["description"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdBy: json["createdBy"],
        createdById: json["createdById"],
        createdDateTime: DateTime.parse(json["createdDateTime"]),
        modifiedById: json["modifiedById"],
        modifiedDateTime: DateTime.parse(json["modifiedDateTime"]),
        inventoryItems: json["inventoryItems"] == null
            ? null
            : List<InventoryItemElement>.from(json["inventoryItems"]
                .map((x) => InventoryItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organisationId": organisationId,
        "name": name,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "createdBy": createdBy,
        "createdById": createdById,
        "createdDateTime": createdDateTime.toIso8601String(),
        "modifiedById": modifiedById,
        "modifiedDateTime": modifiedDateTime.toIso8601String(),
        "inventoryItems":
            List<dynamic>.from(inventoryItems.map((x) => x.toJson())),
      };
}
