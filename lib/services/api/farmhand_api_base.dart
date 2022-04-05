import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:farmhand/models/auth_user_details_model.dart';
import 'package:farmhand/models/person_details.dart';
import 'package:farmhand/models/storage_locations/storage_locations.dart';
import 'package:farmhand/services/api/jwt_worker.dart';
import 'package:farmhand/services/api/maps/get_maps_geo_location.dart';
import 'package:farmhand/services/api/people/people_details_api.dart';
import 'package:farmhand/services/api/storage_locations/storage_locations_api.dart';
import 'package:farmhand/services/api/users/auth/user_auth_api.dart';
import 'package:farmhand/services/api/work_tasks/work_tasts_api.dart';
import 'package:flutter/cupertino.dart';

///[FarmhandApiBase] contains all api's
class FarmhandApiBase {
  Dio dio;

  /// [FarmhandApiBase] constructor.
  ///
  /// [Dio] client for performing all REST actions

  FarmhandApiBase({@required Dio dio}) {
    this.dio = dio;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<AuthUserDetails> authUserWithCredentials(
      String userName, String password) {
    return AuthUserWithCredentials.init(
        dio: dio, userName: userName, password: password);
  }

  Future<PersonDetails> peopleDetails(int peopleId) {
    this.dio.interceptors.add(JWTWorkerInterceptor(this.dio));
    return PeopleDetials.init(dio: dio, peopleId: peopleId);
  }

  Future<dynamic> workTaskDetails() {
    this.dio.interceptors.add(JWTWorkerInterceptor(this.dio));
    return WorkTasks.init(dio: dio);
  }

  Future<void> getMapGeoLocationDetails(int mapId) {
    this.dio.interceptors.add(JWTWorkerInterceptor(this.dio));
    return MapsGeoLocation.init(dio: dio, mapId: mapId);
  }

  Future<List<StorageLocations>> getAllStorageLocations() {
    this.dio.interceptors.add(JWTWorkerInterceptor(this.dio));
    return GetAllStorageLocations.init(dio: dio);
  }
}
