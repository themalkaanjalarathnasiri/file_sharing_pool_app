import 'package:share_pool/features/group%20management/model/participant_model.dart';

class GroupModel{
  String? groupId;
  String? groupName;
  List<ParticipantModel>? participants;
  List<String>? participantEmails;
  GroupModel({this.groupId, this.groupName, this.participants, this.participantEmails});

  // Convert the GroupModel instance to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'participants': participants?.map((participant) => participant.toJson()).toList(),
      'participantEmails': participantEmails, // Include the participant emails
    };
  }

  // Create a GroupModel instance from JSON data
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'],
      groupName: json['groupName'],
      participants: (json['participants'] as List<dynamic>?)
          ?.map((participantJson) => ParticipantModel.fromJson(participantJson))
          .toList(),
      participantEmails: (json['participantEmails'] as List<dynamic>?)?.cast<String>(), // Parse participant emails
    );
  }


}