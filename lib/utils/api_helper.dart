import 'package:dio/dio.dart';
import 'package:farmhand/services/api/farmhand_api_base.dart';

class ApiHelper {
  static final FarmhandApiBase _api = FarmhandApiBase(dio: Dio());
  static FarmhandApiBase getApiService() {
    return _api;
  }
}
