import 'package:intl/intl.dart';

class FileMngUtils{

 static String formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      double sizeInKb = sizeInBytes / 1024;
      return '${sizeInKb.toStringAsFixed(1)} KB';
    } else {
      double sizeInMb = sizeInBytes / (1024 * 1024);
      return '${sizeInMb.toStringAsFixed(1)} MB';
    }
  }

static String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('MM/dd/yy hh:mm a');
  return formatter.format(dateTime);
}
}