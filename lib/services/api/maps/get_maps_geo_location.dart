import 'package:dio/dio.dart';
import 'package:farmhand/constant.dart';
import 'package:farmhand/models/maps/model_maps_geo_json.dart';
import 'package:flutter/cupertino.dart';

class MapsGeoLocation {
  static Future<void> init({
    @required Dio dio,
    @required int mapId,
  }) async {
    try {
      String mapDataUrl = constantURL + "/maps/geojson/$mapId";
      Response mapDetailsResponse = await dio.get(mapDataUrl);
      print(mapDataUrl + " - SUCCESS");
      // print("Maps Geo Json Response Body :: " +
      //     mapDetailsResponse.data.toString());

      return (mapDetailsResponse.data as List)
          .map((x) => MapsGeoJson.fromJson(x))
          .toList();
    } catch (e) {
      print('Error in Getting Maps Geo Json Details : ' + e.toString());
      if (e is DioError && e.response != null) {
        return Future.error(e.response.data['message']);
      } else {
        // Utils.getStringFromPreferences(
        //   "$mapId-${SharedOfflineData().geojsonMapData}");
        return Future.error('Maps Geo Json Details : Unexpected Error Occured');
      }
    }
  }
}
