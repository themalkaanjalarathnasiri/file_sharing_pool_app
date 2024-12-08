
import 'package:share_pool/common/utils/regex_helper.dart';

class GroupMngTextfieldValidatior {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a email address';
    } else if (!RegExp(RegexHelper.email_regex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the input is valid
  }


  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid group name';
    }
    else if (value.length<=3){
      return 'Please enter a valid group name';
    }
    return null; // Return null if the input is valid
  }


}
