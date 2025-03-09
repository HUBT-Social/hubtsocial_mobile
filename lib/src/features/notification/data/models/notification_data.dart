class NotificationData {
  final String title;
  final String body;
  final String? imageUrl;
  final String type;
  final String token;

  NotificationData({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.token,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'],
      type: json['type'] ?? 'default',
      token: json['token'] ?? '',
    );
  }
} 