import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();

  const settings = InitializationSettings(android: android, iOS: ios);

  await _notifications.initialize(settings);

  final androidPlugin = _notifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
  
}

  static Future<void> showNotification(String title, String body) async {

    const android = AndroidNotificationDetails(
      'timer_channel',
      'Timer de Foco',
      channelDescription: 'Notificações do timer de foco',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    await _notifications.show(
      0,
      title,
      body,
      const NotificationDetails(android: android),
    );
  }
}


