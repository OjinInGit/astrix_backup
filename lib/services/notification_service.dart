import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _enabled = true;

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  static void setEnabled(bool v) => _enabled = v;

  static Future<void> show(String title, String body) async {
    if (!_enabled) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'astrix_dvc',
        'Astrix DVC',
        channelDescription: 'Astrix DVC Alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
