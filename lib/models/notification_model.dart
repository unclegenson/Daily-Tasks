import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleDailyNotification() async {
  await FlutterLocalNotificationsPlugin().zonedSchedule(
    0,
    'Daily Tasks',
    'add your tomorow tasks now for better performance',
    _nextInstanceOfTenAM(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
          'daily notification channel id', 'daily notification channel name',
          channelDescription: 'daily notification description'),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 22);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
