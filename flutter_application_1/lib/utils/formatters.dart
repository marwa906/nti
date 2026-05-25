import 'package:flutter/material.dart';

import '../models/models.dart';

String formatMonth(int month, AppLanguage language) {
  const List<String> englishMonths = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  const List<String> arabicMonths = <String>[
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  return language == AppLanguage.arabic
      ? arabicMonths[month - 1]
      : englishMonths[month - 1];
}

String formatWeekday(int weekday, AppLanguage language) {
  const List<String> englishDays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  const List<String> arabicDays = <String>[
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];
  return language == AppLanguage.arabic
      ? arabicDays[weekday - 1]
      : englishDays[weekday - 1];
}

String formatShortDate(DateTime date, AppLanguage language) {
  if (language == AppLanguage.arabic) {
    return '${date.day} ${formatMonth(date.month, language)}';
  }
  return '${formatMonth(date.month, language)} ${date.day}';
}

String formatLongDate(DateTime date, AppLanguage language) {
  if (language == AppLanguage.arabic) {
    return '${formatWeekday(date.weekday, language)}، ${date.day} ${formatMonth(date.month, language)} ${date.year}';
  }
  return '${formatWeekday(date.weekday, language)}, ${formatMonth(date.month, language)} ${date.day}, ${date.year}';
}

String formatClock(TimeOfDay time, AppLanguage language) {
  final int hourOfPeriod = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final String minute = time.minute.toString().padLeft(2, '0');
  final String suffix = time.period == DayPeriod.am
      ? (language == AppLanguage.arabic ? 'ص' : 'AM')
      : (language == AppLanguage.arabic ? 'م' : 'PM');
  return '$hourOfPeriod:$minute $suffix';
}

DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

