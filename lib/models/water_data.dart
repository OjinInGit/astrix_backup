class WaterData {
  final double dissolvedOxygen;
  final double ph;
  final double temperature;
  final double turbidity;
  final String category;
  final DateTime timestamp;

  const WaterData({
    required this.dissolvedOxygen,
    required this.ph,
    required this.temperature,
    required this.turbidity,
    required this.category,
    required this.timestamp,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) => WaterData(
    dissolvedOxygen: (json['do'] as num).toDouble(),
    ph: (json['ph'] as num).toDouble(),
    temperature: (json['temp'] as num).toDouble(),
    turbidity: (json['turbidity'] as num).toDouble(),
    category: json['category'] as String? ?? 'Unknown',
    timestamp:
        DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
  );
}
