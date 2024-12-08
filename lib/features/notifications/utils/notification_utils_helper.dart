

import 'package:intl/intl.dart';

class NotificationUtilsHelper{
 static String formatTimestamp(String timestampString) {
    DateTime timestamp = DateTime.parse(timestampString);
    DateTime now = DateTime.now();

    if (timestamp.year != now.year) {
      return DateFormat('dd/MM/yy').format(timestamp);
    } else if (timestamp.day == now.day && timestamp.month == now.month) {
      return DateFormat('h:mm a').format(timestamp);
    } else {
      return DateFormat('EEEE').format(timestamp);
    }
  }


}