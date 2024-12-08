import '../../../common/utils/regex_helper.dart';

class UserMngTextFieldValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a email address';
    } else if (!RegExp(RegexHelper.email_regex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the input is valid
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    else if(!RegExp(RegexHelper.passwordRegex).hasMatch(value)){
      return "Password should be at least 6 characters long and include lowercase letters, uppercase letters, numbers, and special characters.";
    }
    return null; // Return null if the input is valid
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid name';
    }
    else if (value.length<=2){
      return 'Please enter a valid name';
    }
    return null; // Return null if the input is valid
  }

  static String? validateMobileNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    else if (value.length!=10){
      return 'Please enter phone number with 10 digits';
    }
    return null; // Return null if the input is valid
  }

  static String? validateOfficeLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a office location';
    }
    else if (value.length<=2){
      return 'Please enter a valid office location';
    }
    return null; // Return null if the input is valid
  }

  static String? validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a department name';
    }

    return null; // Return null if the input is valid
  }

  static String? validatePosition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the worker\'s position' ;
    }
    else if (value.length<=2){
      return 'Please enter a valid position';
    }
    return null; // Return null if the input is valid
  }
}
