class LocalImageSave {
  String workID;
  List<String> workTaskImageFileLocal;

  LocalImageSave({this.workID, this.workTaskImageFileLocal});

  LocalImageSave.fromJson(Map<String, dynamic> json) {
    workID = json['workID'];
    workTaskImageFileLocal = json['workTaskImageFileLocal'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workID'] = this.workID;
    data['workTaskImageFileLocal'] = this.workTaskImageFileLocal;
    return data;
  }
}
