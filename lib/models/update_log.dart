class UpdateLog {
  final String id;
  final String message;
  final String type; // 'update' | 'config' | 'feeding' | 'error'
  final DateTime timestamp;

  const UpdateLog({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}
