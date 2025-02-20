import 'package:easy_localization/easy_localization.dart';
import 'package:fc_social_fitness/constants/app_strings.dart';
import 'package:fc_social_fitness/my_app.dart';
import 'package:fc_social_fitness/utils/shared_manager.dart';

class DateOfNow {
  static String dateOfNow() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  static String commentsDateOfNow(String theDate) {
    final DateTime dateOne = DateTime.now();
    final DateTime? dateTwo = DateTime.tryParse(theDate);
    if (dateTwo == null) return "";
    final Duration duration = dateOne.difference(dateTwo);
    int year = (duration.inDays / 256).ceil();
    int month = (duration.inDays / 30).ceil();
    int week = month * 4;
    int day = duration.inDays;
    int hour = duration.inHours;
    int minute = duration.inMinutes;
    int second = duration.inSeconds;
    return second > 60
        ? (minute > 60
            ? (hour > 24
                ? (day > 30
                    ? (week > 4
                        ? (month > 12 ? "$year a" : "$month m")
                        : "$week sett")
                    : "$day g")
                : "$hour h")
            : "$minute m")
        : "$second s";
  }

  static String chattingDateOfNow(
      String theDate, String previousDateOfMessage) {
    DateTime theActualDate = DateTime.parse(theDate);
    DateTime thePreviousDate = DateTime.parse(previousDateOfMessage);
    DateTime now = DateTime.now();

    String dateOfToday = DateFormat("HH:mm",SharedManager.getString(AppStrings.appLocale,defaultValue: 'it')).format(theActualDate);
    String dateOfDay = DateFormat("EEE HH:mm ",SharedManager.getString(AppStrings.appLocale,defaultValue: 'it')).format(theActualDate);
    String dateOfMonth = DateFormat("MMM d, HH:mm",SharedManager.getString(AppStrings.appLocale,defaultValue: 'it')).format(theActualDate);
    String theCompleteDate =
        DateFormat("MMM d, y  h:m a",SharedManager.getString(AppStrings.appLocale,defaultValue: 'it')).format(theActualDate);

    String theDateOTime = theActualDate.year == now.year
        ? (theActualDate.month == now.month
            ? (theActualDate.day == now.day ? "Oggi $dateOfToday" : dateOfDay)
            : dateOfMonth)
        : theCompleteDate;

    DateTime from = _dateTime(theActualDate);
    DateTime to = _dateTime(thePreviousDate);
    int date = from.difference(to).inHours;
    return (!theActualDate.isAtSameMomentAs(thePreviousDate) && date < 1)
        ? ""
        : theDateOTime;
  }
}

DateTime _dateTime(DateTime theDate) => DateTime(
    theDate.year, theDate.month, theDate.day, theDate.hour, theDate.minute);
