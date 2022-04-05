import 'package:farmhand/models/workTask/gps_location.dart';
import 'package:farmhand/models/workTask/worktask_application.dart';

class WorktaskDetails {
  WorktaskDetails({
    this.id,
    this.mapId,
    this.name,
    this.instructions,
    this.workTaskCategoryId,
    this.assignedToId,
    this.assignedById,
    this.estimatedHours,
    this.dueDateTime,
    this.completedDateTime,
    this.hoursBeforeReminder,
    this.priorityId,
    this.comments,
    this.workTaskStatusId,
    this.worktaskapplication,
    this.gpsLocations,
    this.files,
  });

  num id;
  num mapId;
  String name;
  String instructions;
  num workTaskCategoryId;
  num assignedToId;
  num assignedById;
  num estimatedHours;
  DateTime dueDateTime;
  DateTime completedDateTime;
  dynamic hoursBeforeReminder;
  num priorityId;
  dynamic comments;
  num workTaskStatusId;
  WorktaskApplication worktaskapplication;
  List<GpsLocation> gpsLocations;
  dynamic files;

  factory WorktaskDetails.fromJson(Map<String, dynamic> json) =>
      WorktaskDetails(
        id: json["id"],
        mapId: json["mapId"],
        name: json["name"],
        instructions:
            json["instructions"] == null ? null : json["instructions"],
        workTaskCategoryId: json["workTaskCategoryId"],
        assignedToId: json["assignedToId"],
        assignedById:
            json["assignedById"] == null ? null : json["assignedById"],
        estimatedHours:
            json["estimatedHours"] == null ? null : json["estimatedHours"],
        dueDateTime: DateTime.parse(json["dueDateTime"]),
        completedDateTime: json["completedDateTime"] == null
            ? null
            : DateTime.parse(json["completedDateTime"]),
        hoursBeforeReminder: json["hoursBeforeReminder"],
        priorityId: json["priorityId"],
        comments: json["comments"],
        workTaskStatusId: json["workTaskStatusId"],
        worktaskapplication:
            WorktaskApplication.fromJson(json["worktaskapplication"]),
        gpsLocations: List<GpsLocation>.from(
            json["gpsLocations"].map((x) => GpsLocation.fromJson(x))),
        files: json["files"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mapId": mapId,
        "name": name,
        "instructions": instructions == null ? null : instructions,
        "workTaskCategoryId": workTaskCategoryId,
        "assignedToId": assignedToId,
        "assignedById": assignedById == null ? null : assignedById,
        "estimatedHours": estimatedHours == null ? null : estimatedHours,
        "dueDateTime": dueDateTime.toIso8601String(),
        "completedDateTime": completedDateTime == null
            ? null
            : completedDateTime.toIso8601String(),
        "hoursBeforeReminder": hoursBeforeReminder,
        "priorityId": priorityId,
        "comments": comments,
        "workTaskStatusId": workTaskStatusId,
        "worktaskapplication": worktaskapplication.toJson(),
        "gpsLocations": List<dynamic>.from(gpsLocations.map((x) => x.toJson())),
        "files": files,
      };
}
