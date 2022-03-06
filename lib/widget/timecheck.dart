class TimeCheck {
  bool getOpenStatus(
      String startDate, String openTime, String endTime, String closeTime) {
    DateTime now = DateTime.now();
    var openTimes = openTime.split(":");
    var openDates = startDate.split("-");

    var closeTimes = closeTime.split(":");
    var closeDates = startDate.split("-");

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
}
