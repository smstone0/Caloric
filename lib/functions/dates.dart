import 'package:intl/intl.dart';

String getCurrentDate() {
  final now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(now);
}

String getTimeOfDay() {
  DateTime time = DateTime.now();
  if (time.hour >= 0 && time.hour < 12) {
    return "morning";
  } else if (time.hour >= 12 && time.hour < 17) {
    return "afternoon";
  } else {
    return "evening";
  }
}

String getMonth() {
  DateTime time = DateTime.now();
  switch (time.month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    default:
      return "December";
  }
}

String displayDate(DateTime date) {
  final day = date.day;
  final month = DateFormat('MMMM').format(date); // Get full month name
  final suffix = getDaySuffix(day); // Get the ordinal suffix for the day
  return '$day$suffix $month';
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th'; // Special case for 11th, 12th, 13th
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

List<DateTime> getPastWeekDates() {
  final now = DateTime.now();
  return List.generate(7, (index) => now.subtract(Duration(days: index + 1)));
}
