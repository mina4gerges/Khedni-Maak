import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/context/notification_provider.dart';
import 'package:khedni_maak/widgets/error_widget.dart';
import 'package:provider/provider.dart';

class NotificationDriverScreen extends StatelessWidget {
  NotificationDriverScreen({
    Key key,
    this.source,
  }) : super(key: key);

  final String source;

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    List notificationsRiderRequest =
        notificationProvider.getNotificationsRiderRequest;

    _removeNotification(String routeId) {
      for (int i = 0; i < notificationsRiderRequest.length; i++) {
        Map notification = notificationsRiderRequest[i];

        if (notification['routeId'] == routeId) {
          notificationsRiderRequest.removeAt(i);
        }
      }
      notificationProvider
          .setNotificationsRiderRequest(notificationsRiderRequest);
    }

    _onAcceptRequest(String routeId) {
      _removeNotification(routeId);
    }

    _onDeclineRequest(String routeId) {
      _removeNotification(routeId);
    }

    if (notificationsRiderRequest.length == 0)
      return ErrorWidgetDisplay(
        title: 'No notifications',
        subTitle: 'Notifications are empty',
        imagePath: 'truck.png',
      );

    return ListView.builder(
      // padding: const EdgeInsets.all(5),
      itemCount: notificationsRiderRequest.length,
      itemBuilder: (BuildContext context, int index) {
        final route = notificationsRiderRequest[index];
        String from = route['from'];
        String to = route['to'];
        // String driverUsername = route['driverUsername'];
        String routeId = route['routeId'];

        return Container(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          color: Colors.blueAccent,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white60, Colors.white],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text("XXXXXX request to go with you !"),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                RaisedButton(
                  onPressed: () => _onAcceptRequest(routeId),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.green[600],
                  textColor: Colors.white,
                  child: Row(
                    children: [
                      Icon(Icons.check),
                      Text("Accept"),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () => _onDeclineRequest(routeId),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red[600],
                  textColor: Colors.white,
                  child: Row(
                    children: [
                      Icon(FlevaIcons.close),
                      Text("Reject"),
                    ],
                  ),
                ),
              ])
            ],
          ),
        );
        //onTap:onCarTap,
      },
    );
  }
}
