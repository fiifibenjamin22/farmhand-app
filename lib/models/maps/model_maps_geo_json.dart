import 'package:farmhand/models/maps/model_map_feature.dart';

class MapsGeoJson {
  MapsGeoJson({
    this.features,
    this.type,
  });

  List<Feature> features;
  String type;

  factory MapsGeoJson.fromJson(Map<String, dynamic> json) => MapsGeoJson(
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "type": type,
      };
}
