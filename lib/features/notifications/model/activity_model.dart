class ActivityModel {
  String? description;
  String? subDescription;
  String? dateTime;
  String? groupName;
  String? groupId;

  ActivityModel({this.description, this.subDescription, this.dateTime});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    subDescription = json['subDescription'];
    dateTime = json['dateTime'];
    groupName = json['groupName'];
    groupId = json['groupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['subDescription'] = this.subDescription;
    data['dateTime'] = this.dateTime;
    data['groupName'] = this.groupName;
    data['groupId'] = this.groupId;
    return data;
  }
}
