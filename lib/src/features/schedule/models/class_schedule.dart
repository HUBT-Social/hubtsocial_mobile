class ClassSchedule {
  final String id;
  final String name;
  final DateTime startTime;
  
  ClassSchedule({
    required this.id,
    required this.name,
    required this.startTime,
  });

  // Nếu bạn làm việc với API, thêm factory constructor từ JSON
  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      id: json['id'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
    };
  }
} 