import 'package:farmhand/models/workTask/inventory_item.dart';

class ApplicationProduct {
  ApplicationProduct({
    this.inventoryItemId,
    this.applicationCategoryId,
    this.recommendedRate,
    this.rateUnitTypeId,
    this.recommendedReoccurrence,
    this.daysToWithholdPaddock,
    this.fillColour,
    this.colourblindFillColour,
    this.inventoryItem,
  });

  num inventoryItemId;
  num applicationCategoryId;
  num recommendedRate;
  num rateUnitTypeId;
  num recommendedReoccurrence;
  num daysToWithholdPaddock;
  String fillColour;
  dynamic colourblindFillColour;
  InventoryItem inventoryItem;

  factory ApplicationProduct.fromJson(Map<String, dynamic> json) =>
      ApplicationProduct(
        inventoryItemId: json["inventoryItemId"],
        applicationCategoryId: json["applicationCategoryId"],
        recommendedRate: json["recommendedRate"],
        rateUnitTypeId: json["rateUnitTypeId"],
        recommendedReoccurrence: json["recommendedReoccurrence"] == null
            ? null
            : json["recommendedReoccurrence"],
        daysToWithholdPaddock: json["daysToWithholdPaddock"] == null
            ? null
            : json["daysToWithholdPaddock"],
        fillColour: json["fillColour"],
        colourblindFillColour: json["colourblindFillColour"],
        inventoryItem: InventoryItem.fromJson(json["inventoryItem"]),
      );

  Map<String, dynamic> toJson() => {
        "inventoryItemId": inventoryItemId,
        "applicationCategoryId": applicationCategoryId,
        "recommendedRate": recommendedRate,
        "rateUnitTypeId": rateUnitTypeId,
        "recommendedReoccurrence":
            recommendedReoccurrence == null ? null : recommendedReoccurrence,
        "daysToWithholdPaddock":
            daysToWithholdPaddock == null ? null : daysToWithholdPaddock,
        "fillColour": fillColour,
        "colourblindFillColour": colourblindFillColour,
        "inventoryItem": inventoryItem.toJson(),
      };
}
