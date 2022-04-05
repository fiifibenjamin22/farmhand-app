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
  });

  num id;
  num organisationId;
  num inventoryTypeId;
  String name;
  dynamic description;
  num unitPrice;
  dynamic reorderLevel;
  dynamic reorderQuantity;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json["id"],
        organisationId: json["organisationId"],
        inventoryTypeId: json["inventoryTypeId"],
        name: json["name"],
        description: json["description"],
        unitPrice: json["unitPrice"] == null ? null : json["unitPrice"],
        reorderLevel: json["reorderLevel"],
        reorderQuantity: json["reorderQuantity"],
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
      };
}
