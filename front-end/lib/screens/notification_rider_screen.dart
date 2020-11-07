import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/context/notification_provider.dart';
import 'package:khedni_maak/widgets/error_widget.dart';
import 'package:provider/provider.dart';

class NotificationRiderScreen extends StatelessWidget {
  NotificationRiderScreen({
    Key key,
    this.source,
  }) : super(key: key);

  final String source;

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    List notificationsAddRoute = notificationProvider.getNotificationsAddRoute;

    _removeNotification(String routeId) {
      for (int i = 0; i < notificationsAddRoute.length; i++) {
        Map notification = notificationsAddRoute[i];

        if (notification['routeId'] == routeId) {
          notificationsAddRoute.removeAt(i);
        }
      }
      notificationProvider.setNotificationsAddRoute(notificationsAddRoute);
    }

    if (notificationsAddRoute.length == 0)
      return ErrorWidgetDisplay(
        title: 'No notifications',
        subTitle: 'Notifications are empty',
        imagePath: 'truck.png',
      );

    return ListView.builder(
      // padding: const EdgeInsets.all(5),
      itemCount: notificationsAddRoute.length,
      itemBuilder: (BuildContext context, int index) {
        final route = notificationsAddRoute[index];
        String from = route['from'];
        String to = route['to'];
        // String driverUsername = route['driverUsername'];
        String routeId = route['routeId'];

        return Container(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50], Colors.blue[50]],
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text("XXXXXX accepted your request"),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text("From "),
                      Text(from),
                      Text(" To "),
                      Text(to),
                    ],
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
              Column(children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[400],
                  ),
                  onPressed: () => _removeNotification(routeId),
                ),
              ]),
            ],
          ),
        );
        //onTap:onCarTap,
      },
    );
  }
}
