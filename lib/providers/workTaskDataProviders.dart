import 'package:farmhand/models/workTask/singleWorkTaskModel.dart';
import 'package:flutter/material.dart';

class WorkTaskDataProvider extends ChangeNotifier {
  String noteAreaGet;

  SingleWorkTask workTaskSingleData = SingleWorkTask();
  String worktaskID;
  List paddockNames = [];
}
