import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../services/api_service.dart';

class NotificationController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<AppNotification> notifications = [];

  Future<void> fetchNotifications(String userId, String idToken) async {
    try {
      final response = await _apiService.getNotifications(userId, idToken);
      notifications = response
          .map<AppNotification>((json) => AppNotification.fromJson(json))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error al obtener notificaciones: $e');
    }
  }
}
