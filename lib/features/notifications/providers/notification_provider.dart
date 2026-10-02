import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../core/services/storage_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = StorageService.getNotifications();

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await StorageService.saveNotifications(_notifications);
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    await StorageService.saveNotifications(_notifications);
    notifyListeners();
  }

  Future<void> addNotification(String title, String message, String type) async {
    final notif = NotificationModel(
      id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
    );
    _notifications.insert(0, notif);
    await StorageService.saveNotifications(_notifications);
    notifyListeners();
  }
}
