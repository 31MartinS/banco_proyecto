class AppNotification {
  final int id;
  final String message;
  final String date;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.message,
    required this.date,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      message: json['message'],
      date: json['notification_date'],
      isRead: json['is_read'] == 1 || json['is_read'] == true,
    );
  }
}
