import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List _notificationsAddRoute = [];

  List get getNotificationsAddRoute => _notificationsAddRoute;

  void setNotificationsAddRoute(List notificationAddRoute) {
    _notificationsAddRoute = notificationAddRoute;
    notifyListeners();
  }

  List _notificationsRiderRequest = [];

  List get getNotificationsRiderRequest => _notificationsRiderRequest;

  void setNotificationsRiderRequest(List notificationsRiderRequest) {
    _notificationsRiderRequest = notificationsRiderRequest;
    notifyListeners();
  }
}
