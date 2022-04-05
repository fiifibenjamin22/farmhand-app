import 'package:farmhand/constant.dart';
import 'package:farmhand/models/map_element.dart';
import 'package:farmhand/models/organisation.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/pages/mapView/farms_list_locations_screen.dart';
import 'package:farmhand/utils/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension ListPaddockLocationsExt on ListPaddockLocationsState {
  loadAllLocationsData() async {
    preferences = await SharedPreferences.getInstance();
    var personID = preferences.getInt(SharedOfflineData().peopleId);
    PersonDetails personDetails =
        await ApiHelper.getApiService().peopleDetails(personID);

    allOrganisationList = personDetails.organisations;
    for (int i = 0; i < allOrganisationList.length; i++) {
      Organisation organisation = (allOrganisationList[i]);
      List organisationMaps = organisation.maps;

      if (organisationMaps.length > 0) {
        for (int i = 0; i < organisationMaps.length; i++) {
          MapElement mapElement = (organisationMaps[i]);
          String mapName = mapElement.name;
          if (mapName.isNotEmpty) {
            locationName.add(mapName);
            locationType.add("farm");
            mapIdList.add(mapElement.id);
          }
        }
      }

      // part of storageLocations
      // if (widget.includeStorageLocations) {
      //   List storageLocations = organisation.storageLocations;
      //
      //   if (storageLocations.length > 0) {
      //     for (int i = 0; i < storageLocations.length; i++) {
      //       StorageLocations storageLocation = (storageLocations[i]);
      //       String storageLocationName = storageLocation.name;
      //       if (storageLocationName.isNotEmpty) {
      //         locationName.add(storageLocationName);
      //         storageLocationsList.add(storageLocationName);
      //         locationType.add("storage");
      //         mapIdList.add(storageLocation.id);
      //       }
      //     }
      //   }
      // }
    }

    // ignore: invalid_use_of_protected_member
    setState(() {
      isLoading = false;
    });
  }
}
