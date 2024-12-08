import 'dart:developer';

class UserMngUtils{

  static String getInitials(String fullName) {
    try{
      List<String> nameParts = fullName.split(' ');

      // Get the first letter of the first name
      String firstInitial = nameParts.first.isNotEmpty ? nameParts.first[0] : '';

      // Get the first letter of the last name
      String lastInitial = nameParts.length > 1 && nameParts.last.isNotEmpty ? nameParts.last[0] : '';

      return '$firstInitial$lastInitial'.toUpperCase();
    }catch(e){

      log(e.toString());
      return fullName;
    }

  }
}