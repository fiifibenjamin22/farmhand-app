class GpsLocation {
  GpsLocation({
    this.id,
    this.name,
    this.x,
    this.y,
    this.latitude,
    this.longitude,
    this.paddockId,
  });

  num id;
  String name;
  dynamic x;
  dynamic y;
  dynamic latitude;
  dynamic longitude;
  num paddockId;

  factory GpsLocation.fromJson(Map<String, dynamic> json) => GpsLocation(
        id: json["id"],
        name: json["name"],
        x: json["x"],
        y: json["y"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        paddockId: json["paddockId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "x": x,
        "y": y,
        "latitude": latitude,
        "longitude": longitude,
        "paddockId": paddockId,
      };
}
