import 'package:farmhand/models/storage_locations/inventory_item.dart';

class InventoryItemElement {
  InventoryItemElement({
    this.id,
    this.inventoryItemId,
    this.storageLocationId,
    this.level,
    this.effectiveDateTime,
    this.inventoryItem,
  });

  num id;
  num inventoryItemId;
  num storageLocationId;
  num level;
  DateTime effectiveDateTime;
  InventoryItem inventoryItem;

  factory InventoryItemElement.fromJson(Map<String, dynamic> json) =>
      InventoryItemElement(
        id: json["id"],
        inventoryItemId: json["inventoryItemId"],
        storageLocationId: json["storageLocationId"],
        level: json["level"],
        effectiveDateTime: DateTime.parse(json["effectiveDateTime"]),
        inventoryItem: json["inventoryItem"] == null
            ? null
            : InventoryItem.fromJson(json["inventoryItem"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inventoryItemId": inventoryItemId,
        "storageLocationId": storageLocationId,
        "level": level,
        "effectiveDateTime": effectiveDateTime.toIso8601String(),
        "inventoryItem": inventoryItem.toJson(),
      };
}
