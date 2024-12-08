// Define the user model class
class UserModel {
  String? uid;
  String? name;
   String? email;
   String? password;
   String? mobile;
   String? officeLocation;
   String? position;
   String? department;
   String? userRole;
   String? groupRole;
   //for group user select
  bool? isSelected;

  UserModel({
     this.uid,
     this.name,
     this.email,
     this.password,
     this.mobile,
     this.officeLocation,
     this.position,
     this.department,
     this.userRole,
     this.groupRole,
     this.isSelected,
  });

  // Convert the UserModel instance to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'mobile': mobile,
      'officeLocation': officeLocation,
      'position': position,
      'department': department,
      'userRole': userRole,
      'groupRole': groupRole,
      'isSelected': isSelected,
    };
  }

  // Create a UserModel instance from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      mobile: json['mobile'],
      officeLocation: json['officeLocation'],
      position: json['position'],
      department: json['department'],
      userRole: json['userRole'],
      groupRole: json['groupRole'],
      isSelected: json['isSelected'],
    );
  }
}
