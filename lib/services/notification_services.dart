import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/ui/screens/notification_screen.dart';

import '../models/task.dart';


class NotifyHelper
{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();

  initNotification()
  async {

    //tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,);

    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );

  }


  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.to(NotificationScreen(payload: payload!));
  }

  displayNotification({required String title, required String body})
  async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
    );

    // DarwinNotificationDetails iosNotificationDetails =  DarwinNotificationDetails();

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: 'Default_Sound'
    );

  }


  Future<void> scheduledNotification(int hour, int minutes, Task task) async
  {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.note,
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _nextInstanceOfTenAM(hour, minutes),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '${task.title}|${task.note}|${task.startTime}|');
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Future<void> _configureLocalTimeZone() async {
  //   tz.initializeTimeZones();
  //   final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(timeZoneName));
  // }

  // Future selectNotification(String payload) async
  // {
  //
  //   debugPrint('Notification payload: $payload');
  //
  //   await Get.to(NotificationScreen(payload: payload));
  // }

  void onDidReceiveLocalNotification(
  int id, String? title, String? body, String? payload) async {

    Get.dialog(Text(body!));
  }


  void requestIOSPermissions()
  {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is $payload');
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }
}