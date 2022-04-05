import 'package:farmhand/models/workTask/application_product.dart';

class WorktaskApplication {
  WorktaskApplication({
    this.applicationProductId,
    this.applicationRate,
    this.rateUnitTypeId,
    this.productAmountNeeded,
    this.rateUnitType,
    this.applicationProduct,
  });

  num applicationProductId;
  num applicationRate;
  num rateUnitTypeId;
  num productAmountNeeded;
  String rateUnitType;
  ApplicationProduct applicationProduct;

  factory WorktaskApplication.fromJson(Map<String, dynamic> json) =>
      WorktaskApplication(
        applicationProductId: json["applicationProductId"],
        applicationRate: json["applicationRate"],
        rateUnitTypeId: json["rateUnitTypeId"],
        productAmountNeeded: json["productAmountNeeded"] == null
            ? null
            : json["productAmountNeeded"],
        rateUnitType: json["rateUnitType"],
        applicationProduct:
            ApplicationProduct.fromJson(json["applicationProduct"]),
      );

  Map<String, dynamic> toJson() => {
        "applicationProductId": applicationProductId,
        "applicationRate": applicationRate,
        "rateUnitTypeId": rateUnitTypeId,
        "productAmountNeeded":
            productAmountNeeded == null ? null : productAmountNeeded,
        "rateUnitType": rateUnitType,
        "applicationProduct": applicationProduct.toJson(),
      };
}
