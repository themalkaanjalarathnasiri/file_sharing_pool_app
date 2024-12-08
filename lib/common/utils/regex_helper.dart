class RegexHelper {
  static const email_regex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$';

}
