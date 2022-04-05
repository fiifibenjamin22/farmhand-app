class PutworkTask {
  int applicationCategoryId;
  int workTaskID;
  int paddockEventTypeId;
  String clearDateTime;
  String endDateTime;
  String notes;
  int workTaskStatusId;
  List<Paddocks> paddocks;

  PutworkTask(
      {this.applicationCategoryId,
      this.workTaskID,
      this.paddockEventTypeId,
      this.clearDateTime,
      this.endDateTime,
      this.notes,
      this.workTaskStatusId,
      this.paddocks});

  PutworkTask.fromJson(Map<String, dynamic> json) {
    applicationCategoryId = json['applicationCategoryId'];
    workTaskID = json['WorkTaskID'];
    paddockEventTypeId = json['paddockEventTypeId'];
    clearDateTime = json['clearDateTime'];
    endDateTime = json['endDateTime'];
    notes = json['notes'];
    workTaskStatusId = json['workTaskStatusId'];
    if (json['paddocks'] != null) {
      paddocks = <Paddocks>[];
      json['paddocks'].forEach((v) {
        paddocks.add(new Paddocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationCategoryId'] = this.applicationCategoryId;
    data['WorkTaskID'] = this.workTaskID;
    data['paddockEventTypeId'] = this.paddockEventTypeId;
    data['clearDateTime'] = this.clearDateTime;
    data['endDateTime'] = this.endDateTime;
    data['notes'] = this.notes;
    data['workTaskStatusId'] = this.workTaskStatusId;
    if (this.paddocks != null) {
      data['paddocks'] = this.paddocks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paddocks {
  int key;
  Value value;

  Paddocks({this.key, this.value});

  Paddocks.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.value != null) {
      data['value'] = this.value.toJson();
    }
    return data;
  }
}

class Value {
  double latitude;
  double longitude;
  String time;

  Value({this.latitude, this.longitude, this.time});

  Value.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['time'] = this.time;
    return data;
  }
}
