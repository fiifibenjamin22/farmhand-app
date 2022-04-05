class Properties {
  Properties({
    this.isSelected,
    this.entityTypeId,
    this.lineColour,
    this.lineThickness,
    this.fillColour,
    this.transparency,
    this.indexId,
    this.id,
    this.paddockId,
    this.paddockName,
    this.paddockCrop,
    this.labelLocation,
    this.area,
    this.areaUnit,
  });

  bool isSelected;
  num entityTypeId;
  String lineColour;
  double lineThickness;
  String fillColour;
  num transparency;
  num indexId;
  num id;
  num paddockId;
  String paddockName;
  dynamic paddockCrop;
  dynamic labelLocation;
  dynamic area;
  dynamic areaUnit;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        isSelected: json["isSelected"],
        entityTypeId: json["entityTypeId"],
        lineColour: json["lineColour"],
        lineThickness: json["lineThickness"].toDouble(),
        fillColour: json["fillColour"],
        transparency: json["transparency"],
        indexId: json["indexID"],
        id: json["id"],
        paddockId: json["paddockID"],
        paddockName: json["paddockName"],
        paddockCrop: json["paddockCrop"],
        labelLocation: json["labelLocation"],
        area: json["area"],
        areaUnit: json["areaUnit"],
      );

  Map<String, dynamic> toJson() => {
        "isSelected": isSelected,
        "entityTypeId": entityTypeId,
        "lineColour": lineColour,
        "lineThickness": lineThickness,
        "fillColour": fillColour,
        "transparency": transparency,
        "indexID": indexId,
        "id": id,
        "paddockID": paddockId,
        "paddockName": paddockName,
        "paddockCrop": paddockCrop,
        "labelLocation": labelLocation,
        "area": area,
        "areaUnit": areaUnit,
      };
}
