import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List _notifications = [];

  List get getNotifications => _notifications;

  void setNotifications(List notification) {
    _notifications = notification;
    notifyListeners();
  }
}
