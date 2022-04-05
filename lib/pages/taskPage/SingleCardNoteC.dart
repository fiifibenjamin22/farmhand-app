import 'dart:convert';
import 'dart:io';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/taskPage/extensions/taskNoteCExtension.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleCardNoteC extends StatefulWidget {
  @override
  SingleCardNoteCState createState() => SingleCardNoteCState();
}

class SingleCardNoteCState extends State<SingleCardNoteC> {
  List<File> imageFile = [];
  List<File> imageFileUploaded = [];
  List imageFileCachedPath = [];
  List imageFileUploadedCachedPath = [];
  bool imagecheck = false;
  List<Widget> imageLocal = [];
  List<Widget> imageUpload = [];
  List<Widget> imageFinal = [];

  @override
  Widget build(BuildContext context) {
    //Image Upload File Control at first
    var sendingString = Provider.of<WorkTaskDataProvider>(context);
    String listImageLocalPath = Utils.getStringFromPreferences(
        "${SharedOfflineData().workTaskImageFileLocal}");
    String listImageUploadedPath = Utils.getStringFromPreferences(
        "${SharedOfflineData().workTaskImageFileUploaded}");
    if (listImageLocalPath.isNotEmpty) {
      List cache = json.decode(listImageLocalPath);
      List cachePath = [];
      List<File> filecollection = [];
      for (var cacheItem in cache) {
        if (cacheItem["workID"] ==
            sendingString.workTaskSingleData.id.toString()) {
          for (var workTaskImageFileLocalItem
              in cacheItem["workTaskImageFileLocal"]) {
            if (File(workTaskImageFileLocalItem).existsSync()) {
              filecollection.add(File(workTaskImageFileLocalItem));
              cachePath.add(workTaskImageFileLocalItem);
            }
          }
        }
      }
      imageFile = filecollection;
      imageFileCachedPath = cachePath;
      imagecheck = true;
    }
    if (listImageUploadedPath.isNotEmpty) {
      List cache = json.decode(listImageUploadedPath);
      List cachePath = [];
      List<File> filecollection = [];
      for (var cacheItem in cache) {
        if (cacheItem["workID"] ==
            sendingString.workTaskSingleData.id.toString()) {
          for (var workTaskImageFileUploadItem
              in cacheItem["workTaskImageFileLocal"]) {
            if (File(workTaskImageFileUploadItem).existsSync()) {
              filecollection.add(File(workTaskImageFileUploadItem));
              cachePath.add(workTaskImageFileUploadItem);
            }
          }
        }
      }
      imageFileUploaded = filecollection;
      imageFileUploadedCachedPath = cachePath;
      imagecheck = true;
    }
    //Image Upload File Creation
    imageLocal = imageFile
        .map((localelement) => Stack(
              children: [
                Card(
                  child: Image.file(
                    localelement,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/imageLocal.png"),
                    ),
                  ),
                ),
              ],
            ))
        .toList();
    imageUpload = imageFileUploaded
        .map((uploadelement) => Stack(
              children: [
                Card(
                  child: Image.file(
                    uploadelement,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset("assets/imageUploaded.png"),
                    ),
                  ),
                ),
              ],
            ))
        .toList();
    imageFinal = imageUpload + imageLocal;

    double equalSpace = 10.0;
    double equalSpaceinCard = widthin * 5;
    double commonBorderRadius = 20;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Card(
            elevation: 6,
            shadowColor: Colors.blue.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(commonBorderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(equalSpaceinCard),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          sendingString.noteAreaGet = val;
                          print("noteAreaGet:: ${sendingString.noteAreaGet}");
                        });
                      },
                      initialValue: sendingString.workTaskSingleData.comments,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "Add your notes here..",
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: textsizein + 6,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                    ),
                  ),
                  SizedBox(
                    height: equalSpaceinCard - 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Wrap(
                        spacing: 10,
                        children: [
                          InkWell(
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onTap: () {
                              showPickerImageIn(context, sendingString);
                            },
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        imagecheck
            ? SizedBox(
                height: equalSpace,
              )
            : SizedBox.shrink(),
        imagecheck
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      imageFinal.length, (index) => imageFinal[index]),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
