import 'package:farmhand/models/maps/model_map_properties.dart';
import 'package:farmhand/models/maps/model_maps_geometry.dart';

class Feature {
  Feature({
    this.geometry,
    this.properties,
    this.type,
  });

  Geometry geometry;
  Properties properties;
  String type;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
        "properties": properties.toJson(),
        "type": type,
      };
}
