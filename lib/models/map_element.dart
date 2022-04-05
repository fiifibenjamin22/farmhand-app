class MapElement {
  MapElement({
    this.id,
    this.name,
    this.organisationId,
    this.version,
    this.paddocks,
    this.storageLocations,
  });

  int id;
  dynamic name;
  int organisationId;
  int version;
  dynamic paddocks;
  dynamic storageLocations;

  factory MapElement.fromJson(Map<String, dynamic> json) => MapElement(
        id: json["id"],
        name: json["name"],
        organisationId: json["organisationID"],
        version: json["version"],
        paddocks: json["paddocks"],
        storageLocations: json["storageLocations"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "organisationID": organisationId,
        "paddocks": paddocks,
        "storageLocations": storageLocations,
        "version": version,
      };
}
