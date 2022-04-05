import 'dart:convert';
import 'dart:io';

import 'package:farmhand/constant.dart';
import 'package:farmhand/pages/taskPage/SingleCardNoteC.dart';
import 'package:farmhand/providers/workTaskDataProviders.dart';
import 'package:farmhand/services/imageUploadWorkTask.dart';
import 'package:farmhand/utils/common_utils.dart';
import 'package:farmhand/widgets/common_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

extension SingleCardNoteC on SingleCardNoteCState {
  imgPickerIN(workid, sourceGet) async {
    try {
      final File pickedFile =
          // ignore: deprecated_member_use
          await ImagePicker.pickImage(
              source: sourceGet,
              imageQuality: 50,
              maxHeight: 1000,
              maxWidth: 500);
      if (pickedFile == null) {
        showToast("no Image selected", context,
            durationIN: 3, gravityIN: Toast.BOTTOM);
        return;
      } else {
        // ignore: invalid_use_of_protected_member
        setState(() {
          imagecheck = true;
          imageFileCachedPath.add(pickedFile.path);
          imageFile.add(pickedFile);
          String checkLocalImageStringDecode = Utils.getStringFromPreferences(
              "${SharedOfflineData().workTaskImageFileLocal}");
          List checkLocalImageList = checkLocalImageStringDecode.isNotEmpty
              ? json.decode(checkLocalImageStringDecode)
              : [];
          Map localimageNotebyWorkid = {
            'workID': workid.toString(),
            'workTaskImageFileLocal': imageFileCachedPath
          };
          if (checkLocalImageList.isNotEmpty) {
            bool checkImageIN = false;
            for (var checkLocalImageListItem in checkLocalImageList) {
              if (checkLocalImageListItem['workID'] == workid.toString()) {
                checkLocalImageListItem['workTaskImageFileLocal'] =
                    imageFileCachedPath;
                checkImageIN = true;
              }
            }
            if (!checkImageIN) {
              checkLocalImageList.add(localimageNotebyWorkid);
            }
          } else {
            checkLocalImageList.add(localimageNotebyWorkid);
          }

          String listFileLocalEncode = json.encode(checkLocalImageList);
          Utils.setStringToPreferences(
              "${SharedOfflineData().workTaskImageFileLocal}",
              listFileLocalEncode);
          //print("${workid.toString()} ${checkLocalImageList.length}");
          imageUploadFunction();
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void showPickerImageIn(context, sendingString) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.camera_alt_rounded),
                      title: new Text('Camera'),
                      onTap: () {
                        imgPickerIN(sendingString.workTaskSingleData.id,
                            ImageSource.camera);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        imgPickerIN(sendingString.workTaskSingleData.id,
                            ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  imageUploadFunction() {
    var sendingString =
        Provider.of<WorkTaskDataProvider>(context, listen: false);
    workTaskImageUpload(imageFile, sendingString.workTaskSingleData.id)
        .then((value) {
      if (value == "true") {
        // ignore: invalid_use_of_protected_member
        setState(() {
          showToast("upload Successful", context,
              durationIN: 3, gravityIN: Toast.BOTTOM);
          for (File imageFileItem in imageFile) {
            if (!imageFileUploaded.contains(imageFileItem)) {
              imageFileUploadedCachedPath.add(imageFileItem.path);
              imageFileUploaded.add(imageFileItem);
            }
          }
//--------------------  getting all local data to eluminated the current task------------
          String workTaskImageFileLocalStringDecode =
              Utils.getStringFromPreferences(
                  "${SharedOfflineData().workTaskImageFileLocal}");
          List workTaskImageFileLocalCheckList =
              json.decode(workTaskImageFileLocalStringDecode);
          // print(
          //     "workTaskImageFileLocalCheckList :: $workTaskImageFileLocalCheckList");
          List dummy = [];
          for (var workTaskImageFileLocalCheckListItem
              in workTaskImageFileLocalCheckList) {
            if (workTaskImageFileLocalCheckListItem['workID'] !=
                sendingString.workTaskSingleData.id.toString()) {
              dummy.add(workTaskImageFileLocalCheckListItem);
            }
          }
          workTaskImageFileLocalCheckList = dummy;
          if (workTaskImageFileLocalCheckList.isNotEmpty) {
            String workTaskImageFileLocalStringEncode =
                json.encode(workTaskImageFileLocalCheckList);
            Utils.setStringToPreferences(
                "${SharedOfflineData().workTaskImageFileLocal}",
                workTaskImageFileLocalStringEncode);
          } else {
            Utils.removeFromPreferences(
                "${SharedOfflineData().workTaskImageFileLocal}");
          }
//--------------------  End ----------------------------

//------------ getting all upload data to combaine the image recently uploaded in current task ------------
          String checkImageFileUploadedStringDecode =
              Utils.getStringFromPreferences(
                  "${SharedOfflineData().workTaskImageFileUploaded}");
          List checkImageFileUploadedList =
              checkImageFileUploadedStringDecode.isNotEmpty
                  ? json.decode(checkImageFileUploadedStringDecode)
                  : [];
          Map localimageNotebyWorkid = {
            'workID': sendingString.workTaskSingleData.id.toString(),
            'workTaskImageFileLocal': imageFileUploadedCachedPath
          };
          if (checkImageFileUploadedList.isNotEmpty) {
            bool checkImageIN = false;
            for (var checkImageFileUploadedListItem
                in checkImageFileUploadedList) {
              if (checkImageFileUploadedListItem['workID'] ==
                  sendingString.workTaskSingleData.id.toString()) {
                checkImageFileUploadedListItem['workTaskImageFileLocal'] =
                    imageFileUploadedCachedPath;
                checkImageIN = true;
              }
            }
            if (!checkImageIN) {
              checkImageFileUploadedList.add(localimageNotebyWorkid);
            }
          } else {
            checkImageFileUploadedList.add(localimageNotebyWorkid);
          }
          String listFileUploadedStringEncode =
              json.encode(checkImageFileUploadedList);
          Utils.setStringToPreferences(
              "${SharedOfflineData().workTaskImageFileUploaded}",
              listFileUploadedStringEncode);

          imageFileCachedPath = [];
          imageFile = [];
        });
      } else if (value == "NoInternet") {
        showToast("Stored in local", context,
            durationIN: 3, gravityIN: Toast.BOTTOM);
      } else {
        showToast("Invalid format to upload or Token Expiry", context,
            durationIN: 3, gravityIN: Toast.BOTTOM);
      }
    });
  }
}
