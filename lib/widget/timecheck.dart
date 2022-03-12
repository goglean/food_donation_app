import 'package:food_donating_app/widget/charity.dart';

class TimeCheck {
  bool getResOpenStatus(
      String startDate, String openTime, String endDate, String closeTime) {
    DateTime now = DateTime.now();
    var openTimes = openTime.split(":");
    var openDates = startDate.split("-");
    var closeTimes = closeTime.split(":");
    var closeDates = endDate.split("-");

    // DateTime(2020, 7, 6, 18, 00)
    DateTime stDate = DateTime(
        int.parse(openDates[0]),
        int.parse(openDates[1]),
        int.parse(openDates[2]),
        int.parse(openTimes[0]),
        int.parse(openTimes[1]));

    DateTime enDate = DateTime(
        int.parse(closeDates[0]),
        int.parse(closeDates[1]),
        int.parse(closeDates[2]),
        int.parse(closeTimes[0]),
        int.parse(closeTimes[1]));

    // print(now.isAfter(stDate) && now.isBefore(enDate));

    return now.isAfter(stDate) && now.isBefore(enDate);
  }

  bool getCharOpenStatus(Charity curChar) {
    DateTime now = DateTime.now();
    var openTimes = curChar.openCloseTime[(now.weekday - 1) * 2].split(":");
    var closeTimes =
        curChar.openCloseTime[(now.weekday - 1) * 2 + 1].split(":");

    // DateTime(2020, 7, 6, 18, 00)
    DateTime stDate = DateTime(now.year, now.month, now.day,
        int.parse(openTimes[0]), int.parse(openTimes[1]));

    DateTime enDate = DateTime(now.year, now.month, now.day,
        int.parse(closeTimes[0]), int.parse(closeTimes[1]));

    // print(now.isAfter(stDate) && now.isBefore(enDate));

    return now.isAfter(stDate) && now.isBefore(enDate);
  }
}
