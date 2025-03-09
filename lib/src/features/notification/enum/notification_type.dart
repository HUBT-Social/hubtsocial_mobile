enum NotificationType {
  chat('chat'),
  timetable('timetable'),
  system('system'),
  default_type('default');

  final String value;
  const NotificationType(this.value);

  factory NotificationType.fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.default_type,
    );
  }

  String toJson() => value;
} 