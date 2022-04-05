import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import '../constant.dart';

Future workTaskImageUpload(List<File> imageFile, int workTaskID) async {
  ConnectivityResult connectivityResult;
  connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    print(" No Internet in mapWorktask");

    return "NoInternet";
  }
  Dio dio = new Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  var url = constantURL + "/WorkTasks/upload/?TaskId=$workTaskID";
  var headerIN = {
    'Authorization': 'Bearer $jwtToken',
  };
  try {
    for (File imageFileitem in imageFile) {
      if (imageFileitem != null) {
        String fileName = imageFileitem.path.split('/').last;
        print("fileName::$fileName");
        FormData data = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            imageFileitem.path,
            filename: fileName,
          ),
        });

        var response = await dio.post(url,
            options: Options(
              headers: headerIN,
            ),
            data: data);
        if (response.statusCode == 200) {
          print("Image upload ${response.statusCode}");
          return "true";
        } else {
          print("Image upload ${response.statusCode}");
          return "false";
        }
      }
    }
  } catch (e) {
    print("Error in imageUpload $e");
    return "false";
    // throw Exception(e);
  }
}
