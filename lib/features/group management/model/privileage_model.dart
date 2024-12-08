
class GroupRole{
  String? roleName;
  bool? isActive;

  GroupRole({this.isActive, this.roleName});

  // Convert the GroupRole instance to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
      'isActive': isActive,
    };
  }

  // Create a GroupRole instance from JSON data
  factory GroupRole.fromJson(Map<String, dynamic> json) {
    return GroupRole(
      roleName: json['roleName'],
      isActive: json['isActive'],
    );
  }
}