import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feeding_schedule.dart';
import '../models/update_log.dart';
import '../models/water_data.dart';
import '../services/esp32_service.dart';
import '../services/notification_service.dart';

class AppProvider extends ChangeNotifier {
  // ── Settings ──────────────────────────────────────────────
  bool _isDarkMode = false;
  bool _followSystemTheme = true;
  bool _notificationsEnabled = true;
  String _language = 'en';

  // ── Device ────────────────────────────────────────────────
  bool _deviceConnected = false;

  // ── Feeding Config ────────────────────────────────────────
  double _feedAmount = 0.5;
  late List<FeedingSchedule> _schedules;

  // ── Water Data ────────────────────────────────────────────
  WaterData? _currentWaterData;

  // ── Logs ──────────────────────────────────────────────────
  final List<UpdateLog> _logs = [];

  // ── Navigation overlay ────────────────────────────────────
  String _overlay = 'none'; // 'none' | 'controls' | 'manual' | 'settings'

  // ── Getters ───────────────────────────────────────────────
  bool get isDarkMode => _isDarkMode;
  bool get followSystemTheme => _followSystemTheme;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get deviceConnected => _deviceConnected;
  double get feedAmount => _feedAmount;
  List<FeedingSchedule> get schedules => List.unmodifiable(_schedules);
  WaterData? get currentWaterData => _currentWaterData;
  List<UpdateLog> get logs => List.unmodifiable(_logs);
  String get currentOverlay => _overlay;

  // ── Constructor ───────────────────────────────────────────
  AppProvider() {
    _initDefaultSchedules();
    _loadPreferences();
    _addLog('App initialized successfully.', 'update');
    _startConnectivityCheck();
  }

  void _initDefaultSchedules() {
    _schedules = [
      FeedingSchedule(hour: 6, minute: 0, isPM: false),
      FeedingSchedule(hour: 9, minute: 0, isPM: false),
      FeedingSchedule(hour: 12, minute: 0, isPM: true),
      FeedingSchedule(hour: 3, minute: 0, isPM: true),
      FeedingSchedule(hour: 5, minute: 0, isPM: true),
      FeedingSchedule(hour: 7, minute: 0, isPM: true),
    ];
  }

  // ── Preferences ───────────────────────────────────────────
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _followSystemTheme = prefs.getBool('follow_system_theme') ?? true;
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    _language = prefs.getString('language') ?? 'en';
    _feedAmount = prefs.getDouble('feed_amount') ?? 0.5;

    for (int i = 0; i < 6; i++) {
      final h = prefs.getInt('sched_${i}_h');
      final m = prefs.getInt('sched_${i}_m');
      final pm = prefs.getBool('sched_${i}_pm');
      if (h != null && m != null && pm != null) {
        _schedules[i] = FeedingSchedule(hour: h, minute: m, isPM: pm);
      }
    }
    NotificationService.setEnabled(_notificationsEnabled);
    notifyListeners();
  }

  Future<void> _persistSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('follow_system_theme', _followSystemTheme);
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('language', _language);
  }

  Future<void> saveSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('feed_amount', _feedAmount);
    for (int i = 0; i < 6; i++) {
      await prefs.setInt('sched_${i}_h', _schedules[i].hour);
      await prefs.setInt('sched_${i}_m', _schedules[i].minute);
      await prefs.setBool('sched_${i}_pm', _schedules[i].isPM);
    }
    _addLog('Device configuration saved successfully.', 'config');

    if (_deviceConnected) {
      try {
        await Esp32Service.sendSchedules(
          _schedules
              .map((s) => {'hour': s.hour, 'minute': s.minute, 'isPM': s.isPM})
              .toList(),
        );
      } catch (e) {
        _addLog('Failed to sync schedules to device: $e', 'error');
      }
    }
    notifyListeners();
  }

  // ── Setters ───────────────────────────────────────────────
  void toggleDarkMode(bool v) {
    _isDarkMode = v;
    _persistSettings();
    notifyListeners();
  }

  void toggleFollowSystemTheme(bool v) {
    _followSystemTheme = v;
    _persistSettings();
    notifyListeners();
  }

  void toggleNotifications(bool v) {
    _notificationsEnabled = v;
    NotificationService.setEnabled(v);
    _persistSettings();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    _persistSettings();
    notifyListeners();
  }

  void setFeedAmount(double v) {
    _feedAmount = v;
    notifyListeners();
  }

  void updateSchedule(int i, FeedingSchedule s) {
    _schedules[i] = s;
    notifyListeners();
  }

  void setOverlay(String overlay) {
    _overlay = overlay;
    notifyListeners();
  }

  // ── Logs ──────────────────────────────────────────────────
  void _addLog(String message, String type) {
    _logs.insert(
      0,
      UpdateLog(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: message,
        type: type,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addLog(String message, String type) => _addLog(message, type);

  void removeLog(String id) {
    _logs.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  // ── Device Connectivity ───────────────────────────────────
  void _startConnectivityCheck() {
    Timer.periodic(const Duration(seconds: 30), (_) async {
      final connected = await Esp32Service.checkConnectivity();
      if (connected == _deviceConnected) return;

      _deviceConnected = connected;
      if (connected) {
        _addLog('Device connected via Wi-Fi AP.', 'config');
        NotificationService.show('Astrix DVC', 'Device connected.');
        await Esp32Service.syncTime();
        Esp32Service.startPolling(
          onSensorData: _onSensorData,
          onCategoryData: _onCategoryData,
          onError: (e) => _addLog('Device error: $e', 'error'),
        );
      } else {
        _addLog('Device disconnected.', 'error');
        Esp32Service.stopPolling();
      }
      notifyListeners();
    });
  }

  void _onSensorData(Map<String, dynamic> json) {
    final prevCategory = _currentWaterData?.category ?? 'Unknown';
    _currentWaterData = WaterData(
      dissolvedOxygen: (json['do'] as num).toDouble(),
      ph: (json['ph'] as num).toDouble(),
      temperature: (json['temp'] as num).toDouble(),
      turbidity: (json['turbidity'] as num).toDouble(),
      category: prevCategory,
      timestamp: DateTime.now(),
    );
    _addLog('Water parameters updated.', 'update');
    notifyListeners();
  }

  void _onCategoryData(String category) {
    if (_currentWaterData != null) {
      _currentWaterData = WaterData(
        dissolvedOxygen: _currentWaterData!.dissolvedOxygen,
        ph: _currentWaterData!.ph,
        temperature: _currentWaterData!.temperature,
        turbidity: _currentWaterData!.turbidity,
        category: category,
        timestamp: _currentWaterData!.timestamp,
      );
    }
    _addLog('Water quality category updated: $category.', 'update');
    notifyListeners();
  }
}
