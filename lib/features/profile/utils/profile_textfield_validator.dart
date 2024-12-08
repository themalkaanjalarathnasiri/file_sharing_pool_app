import '../../../common/utils/regex_helper.dart';

class ProfileTextFieldValidator {


  static String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    else if(!RegExp(RegexHelper.passwordRegex).hasMatch(value)){
      return "Password should be at least 6 characters long and include lowercase letters, uppercase letters, numbers, and special characters.";
    }
    return null; // Return null if the input is valid
  }


  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new password';
    }
    else if(!RegExp(RegexHelper.passwordRegex).hasMatch(value)){
      return "Password should be at least 6 characters long and include lowercase letters, uppercase letters, numbers, and special characters.";
    }
    return null; // Return null if the input is valid
  }





}
