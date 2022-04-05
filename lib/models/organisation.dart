import 'package:farmhand/models/map_element.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';

class Organisation {
  Organisation({
    this.partyId,
    this.name,
    this.organisationTypeId,
    this.maps,
    this.parentId,
    this.childrenOrganisations,
    // part of storageLocations
    //this.storageLocations,
  });

  int partyId;
  String name;
  int organisationTypeId;
  List<MapElement> maps;
  int parentId;
  List<Organisation> childrenOrganisations;

  //TODO implement storageLocations
  //List<StorageLocations> storageLocations;

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
        partyId: json["partyId"],
        name: json["name"],
        organisationTypeId: json["organisationTypeId"],
        maps: List<MapElement>.from(
            json["maps"].map((x) => MapElement.fromJson(x))),
        parentId: json["parentId"],
        childrenOrganisations: json["childrenOrganisations"] == null
            ? null
            : List<Organisation>.from(json["childrenOrganisations"]
                .map((x) => Organisation.fromJson(x))),
        // part of storageLocations
        // storageLocations: json["storagelocations"] == null
        //     ? null
        //     : List<StorageLocations>.from(json["storagelocations"]
        //         .map((x) => StorageLocations.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "name": name,
        "organisationTypeId": organisationTypeId,
        "maps": List<dynamic>.from(maps.map((x) => x.toJson())),
        "parentId": parentId,
        "childrenOrganisations": childrenOrganisations == null
            ? null
            : List<dynamic>.from(childrenOrganisations.map((x) => x.toJson())),
        // part of storageLocations
        // "storagelocations":
        //     List<dynamic>.from(storageLocations.map((x) => x.toJson())),
      };
}
