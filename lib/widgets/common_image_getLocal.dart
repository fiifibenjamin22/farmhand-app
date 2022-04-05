import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import 'package:image/image.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  Future<String> get _localPath async {
    // final directory = await getExternalStorageDirectory();
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Io.File> getImageFromNetwork(String url) async {
    var cacheManager = DefaultCacheManager();
    Io.File file = await cacheManager.getSingleFile(url);
    return file;
  }

  Future<Io.File> saveImage(String url) async {
    final file = await getImageFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image, width: 256, height: 256);
    String folderPath;
    String fileName;
    var toRet;
    if (url != null) {
      folderPath = url.split("/").sublist(3, 5).join("/").toString();
      fileName = url
          .split("/")
          .sublist(5, 6)
          .join("/")
          .split(".")
          .sublist(0, 1)
          .join()
          .toString();
    }

    if (folderPath != null && fileName != null) {
      var dir = path + "/$folderPath";
      Directory createdDir = await Directory(dir).create(recursive: true);
      final urlGetted = createdDir.path + '/' + fileName + '.png';
      toRet = Io.File(urlGetted)..writeAsBytesSync(encodePng(thumbnail));
      // print("BK store in ${toRet.parent}");
      // Save the thumbnail as a PNG.
    } else {
      toRet = null;
    }

    return toRet;
  }
}
