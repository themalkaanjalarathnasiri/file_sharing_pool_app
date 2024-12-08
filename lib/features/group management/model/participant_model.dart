import 'package:share_pool/features/group%20management/model/privileage_model.dart';

class ParticipantModel{
  String? groupId;
  String? email;
  String? name;
  List<GroupRole>? groupRole;
  ParticipantModel({this.groupId, this.email, this.name, this.groupRole});


  // Convert the ParticipantModel instance to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'email': email,
      'name': name,
      'groupRole': groupRole?.map((role) => role.toJson()).toList(),
    };
  }

  // Create a ParticipantModel instance from JSON data
  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      groupId: json['groupId'],
      email: json['email'],
      name: json['name'],
      groupRole: (json['groupRole'] as List<dynamic>?)
          ?.map((roleJson) => GroupRole.fromJson(roleJson))
          .toList(),
    );
  }
}