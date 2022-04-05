class SingleWorkTask {
  num id;
  num mapId;
  String name;
  String instructions;
  num workTaskCategoryId;
  num assignedToId;
  num assignedById;
  num estimatedHours;
  String dueDateTime;
  String completedDateTime;
  int hoursBeforeReminder;
  num priorityId;
  String comments;
  num workTaskStatusId;
  Worktaskapplication worktaskapplication;
  List<GpsLocations> gpsLocations;
  String files;

  SingleWorkTask({
    this.id,
    this.mapId,
    this.name,
    this.instructions,
    this.workTaskCategoryId,
    this.assignedToId,
    this.assignedById,
    this.estimatedHours,
    this.dueDateTime,
    this.completedDateTime,
    this.hoursBeforeReminder,
    this.priorityId,
    this.comments,
    this.workTaskStatusId,
    this.worktaskapplication,
    this.gpsLocations,
    this.files,
  });

  SingleWorkTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mapId = json['mapId'];
    name = json['name'];
    instructions = json['instructions'];
    workTaskCategoryId = json['workTaskCategoryId'];
    assignedToId = json['assignedToId'];
    assignedById = json['assignedById'];
    estimatedHours = json['estimatedHours'];
    dueDateTime = json['dueDateTime'];
    completedDateTime = json['completedDateTime'];
    hoursBeforeReminder = json['hoursBeforeReminder'];
    priorityId = json['priorityId'];
    comments = json['comments'];
    workTaskStatusId = json['workTaskStatusId'];
    worktaskapplication = json['worktaskapplication'] != null
        ? new Worktaskapplication.fromJson(json['worktaskapplication'])
        : null;
    if (json['gpsLocations'] != null) {
      gpsLocations = <GpsLocations>[];
      json['gpsLocations'].forEach((v) {
        gpsLocations.add(new GpsLocations.fromJson(v));
      });
    }
    files = json['files'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mapId'] = this.mapId;
    data['name'] = this.name;
    data['instructions'] = this.instructions;
    data['workTaskCategoryId'] = this.workTaskCategoryId;
    data['assignedToId'] = this.assignedToId;
    data['assignedById'] = this.assignedById;
    data['estimatedHours'] = this.estimatedHours;
    data['dueDateTime'] = this.dueDateTime;
    data['completedDateTime'] = this.completedDateTime;
    data['hoursBeforeReminder'] = this.hoursBeforeReminder;
    data['priorityId'] = this.priorityId;
    data['comments'] = this.comments;
    data['workTaskStatusId'] = this.workTaskStatusId;
    if (this.worktaskapplication != null) {
      data['worktaskapplication'] = this.worktaskapplication.toJson();
    }
    if (this.gpsLocations != null) {
      data['gpsLocations'] = this.gpsLocations.map((v) => v.toJson()).toList();
    }
    data['files'] = this.files;
    return data;
  }
}

class Worktaskapplication {
  int applicationProductId;
  double applicationRate;
  int rateUnitTypeId;
  double productAmountNeeded;
  String rateUnitType;
  ApplicationProduct applicationProduct;

  Worktaskapplication({
    this.applicationProductId,
    this.applicationRate,
    this.rateUnitTypeId,
    this.productAmountNeeded,
    this.rateUnitType,
    this.applicationProduct,
  });

  Worktaskapplication.fromJson(Map<String, dynamic> json) {
    applicationProductId = json['applicationProductId'];
    applicationRate = json['applicationRate'];
    rateUnitTypeId = json['rateUnitTypeId'];
    productAmountNeeded = json['productAmountNeeded'];
    rateUnitType = json['rateUnitType'];
    applicationProduct = json['applicationProduct'] != null
        ? new ApplicationProduct.fromJson(json['applicationProduct'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationProductId'] = this.applicationProductId;
    data['applicationRate'] = this.applicationRate;
    data['rateUnitTypeId'] = this.rateUnitTypeId;
    data['productAmountNeeded'] = this.productAmountNeeded;
    data['rateUnitType'] = this.rateUnitType;
    if (this.applicationProduct != null) {
      data['applicationProduct'] = this.applicationProduct.toJson();
    }
    return data;
  }
}

class ApplicationProduct {
  int inventoryItemId;
  int applicationCategoryId;
  double recommendedRate;
  int rateUnitTypeId;
  double recommendedReoccurrence;
  int daysToWithholdPaddock;
  String fillColour;
  String colourblindFillColour;
  InventoryItem inventoryItem;

  ApplicationProduct(
      {this.inventoryItemId,
      this.applicationCategoryId,
      this.recommendedRate,
      this.rateUnitTypeId,
      this.recommendedReoccurrence,
      this.daysToWithholdPaddock,
      this.fillColour,
      this.colourblindFillColour,
      this.inventoryItem});

  ApplicationProduct.fromJson(Map<String, dynamic> json) {
    inventoryItemId = json['inventoryItemId'];
    applicationCategoryId = json['applicationCategoryId'];
    recommendedRate = json['recommendedRate'];
    rateUnitTypeId = json['rateUnitTypeId'];
    recommendedReoccurrence = json['recommendedReoccurrence'];
    daysToWithholdPaddock = json['daysToWithholdPaddock'];
    fillColour = json['fillColour'];
    colourblindFillColour = json['colourblindFillColour'];
    inventoryItem = json['inventoryItem'] != null
        ? new InventoryItem.fromJson(json['inventoryItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventoryItemId'] = this.inventoryItemId;
    data['applicationCategoryId'] = this.applicationCategoryId;
    data['recommendedRate'] = this.recommendedRate;
    data['rateUnitTypeId'] = this.rateUnitTypeId;
    data['recommendedReoccurrence'] = this.recommendedReoccurrence;
    data['daysToWithholdPaddock'] = this.daysToWithholdPaddock;
    data['fillColour'] = this.fillColour;
    data['colourblindFillColour'] = this.colourblindFillColour;
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
  double reorderLevel;
  double reorderQuantity;

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

class GpsLocations {
  int id;
  String name;
  String x;
  String y;
  double latitude;
  double longitude;
  int paddockId;

  GpsLocations(
      {this.id,
      this.name,
      this.x,
      this.y,
      this.latitude,
      this.longitude,
      this.paddockId});

  GpsLocations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    x = json['x'];
    y = json['y'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    paddockId = json['paddockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['x'] = this.x;
    data['y'] = this.y;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['paddockId'] = this.paddockId;
    return data;
  }
}
