import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:whatsapp/core/helper/app_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:whatsapp/core/helper/app_logger.dart';
import '../../core/errors/custom_exception.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    try {
      if (_isInitialized) return;

      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          AppLogger.log('Notification clicked: ${details.payload}');
        },
      );

      _isInitialized = true;
      AppLogger.log('NotificationService initialized');
    } catch (e) {
      throw NotificationException('Failed to initialize notifications: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'visit_channel_id',
        'Visits',
        channelDescription: 'Notifications for scheduled visits',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      throw NotificationException('Failed to show notification: $e');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'visit_scheduled_channel_id',
        'Scheduled Visits',
        channelDescription: 'Scheduled notifications for visits',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      final DateTime targetDateTime = DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        12, 
        0,
      );

      final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
        targetDateTime,
        tz.local,
      );
      
      if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
           AppLogger.log("Skipping scheduling for $id as it is in the past: $tzScheduledDate");
           return;
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      
      AppLogger.log('Scheduled notification $id for $tzScheduledDate');
    } catch (e) {
      throw NotificationException('Failed to schedule notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      throw NotificationException('Failed to cancel notification: $e');
    }
  }
}
