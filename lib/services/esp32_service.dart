import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// The ESP32 in AP mode always has this IP address.
const String _base = 'http://192.168.4.1';
const _timeout = Duration(seconds: 10);

class Esp32Service {
  static Timer? _sensorTimer;
  static Timer? _categoryTimer;

  // ── Polling ─────────────────────────────────────────────
  static void startPolling({
    required void Function(Map<String, dynamic>) onSensorData,
    required void Function(String) onCategoryData,
    required void Function(String) onError,
  }) {
    // Immediate fetch on connect
    _doFetchSensor(onSensorData, onError);
    _doFetchCategory(onCategoryData, onError);

    // Hourly sensor poll
    _sensorTimer?.cancel();
    _sensorTimer = Timer.periodic(const Duration(hours: 1), (_) {
      _doFetchSensor(onSensorData, onError);
    });

    // Daily category poll
    _categoryTimer?.cancel();
    _categoryTimer = Timer.periodic(const Duration(hours: 24), (_) {
      _doFetchCategory(onCategoryData, onError);
    });
  }

  static void stopPolling() {
    _sensorTimer?.cancel();
    _categoryTimer?.cancel();
  }

  static void _doFetchSensor(
    void Function(Map<String, dynamic>) onData,
    void Function(String) onError,
  ) {
    fetchSensorData().then(onData).catchError((e) => onError(e.toString()));
  }

  static void _doFetchCategory(
    void Function(String) onData,
    void Function(String) onError,
  ) {
    fetchCategory().then(onData).catchError((e) => onError(e.toString()));
  }

  // ── Endpoints ────────────────────────────────────────────
  static Future<Map<String, dynamic>> fetchSensorData() async {
    final res = await http.get(Uri.parse('$_base/sensor')).timeout(_timeout);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Sensor fetch failed: ${res.statusCode}');
  }

  static Future<String> fetchCategory() async {
    final res = await http.get(Uri.parse('$_base/category')).timeout(_timeout);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as Map)['category'] as String? ?? 'Unknown';
    }
    throw Exception('Category fetch failed: ${res.statusCode}');
  }

  static Future<void> syncTime() async {
    final now = DateTime.now();
    await http
        .post(
          Uri.parse('$_base/time'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'epoch': now.millisecondsSinceEpoch ~/ 1000,
            'timezone_offset': now.timeZoneOffset.inSeconds,
          }),
        )
        .timeout(_timeout);
  }

  static Future<void> sendSchedules(
    List<Map<String, dynamic>> schedules,
  ) async {
    await http
        .post(
          Uri.parse('$_base/schedule'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'schedules': schedules}),
        )
        .timeout(_timeout);
  }

  static Future<bool> checkConnectivity() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/status'))
          .timeout(const Duration(seconds: 5));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
