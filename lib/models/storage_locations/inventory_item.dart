import 'package:farmhand/models/storage_locations/model_application_product.dart';

class InventoryItem {
  InventoryItem({
    this.id,
    this.organisationId,
    this.inventoryTypeId,
    this.name,
    this.description,
    this.unitPrice,
    this.reorderLevel,
    this.reorderQuantity,
    this.applicationProduct,
  });

  num id;
  num organisationId;
  num inventoryTypeId;
  String name;
  dynamic description;
  num unitPrice;
  dynamic reorderLevel;
  dynamic reorderQuantity;
  ApplicationProduct applicationProduct;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json["id"],
        organisationId: json["organisationId"],
        inventoryTypeId: json["inventoryTypeId"],
        name: json["name"],
        description: json["description"],
        unitPrice: json["unitPrice"] == null ? null : json["unitPrice"],
        reorderLevel: json["reorderLevel"],
        reorderQuantity: json["reorderQuantity"],
        applicationProduct: json["applicationProduct"] == null
            ? null
            : ApplicationProduct.fromJson(json["applicationProduct"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organisationId": organisationId,
        "inventoryTypeId": inventoryTypeId,
        "name": name,
        "description": description,
        "unitPrice": unitPrice == null ? null : unitPrice,
        "reorderLevel": reorderLevel,
        "reorderQuantity": reorderQuantity,
        "applicationProduct": applicationProduct.toJson(),
      };
}
