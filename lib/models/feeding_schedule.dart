class FeedingSchedule {
  int hour; // 1–12
  int minute; // 0–55 (step of 5)
  bool isPM;

  FeedingSchedule({
    required this.hour,
    required this.minute,
    required this.isPM,
  });

  String get displayString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m ${isPM ? 'PM' : 'AM'}';
  }

  FeedingSchedule copyWith({int? hour, int? minute, bool? isPM}) =>
      FeedingSchedule(
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        isPM: isPM ?? this.isPM,
      );
}
