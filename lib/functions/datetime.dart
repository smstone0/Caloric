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
