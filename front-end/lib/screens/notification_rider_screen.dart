import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/context/notification_provider.dart';
import 'package:khedni_maak/functions/functions.dart';
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
    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    List notificationsAddRoute = notificationProvider.getNotificationsAddRoute;

    if (notificationsAddRoute.length == 0)
      return ErrorWidgetDisplay(
        title: 'No notifications',
        subTitle: 'Notifications are empty',
        imagePath: 'truck.png',
      );

    return AnimatedList(
      key: listKey,
      initialItemCount: notificationsAddRoute.length,
      itemBuilder: (context, index, animation) {
        final route = notificationsAddRoute[index];
        String from = route['from'];
        String to = route['to'];
        String driverUsername = route['driverUsername'];
        String requestDateTime = route['requestDateTime'];
        String requestReason = route['requestReason'];
        String requestDateTimeStamp = requestDateTime != null
            ? Functions.timeAgoSinceDate(requestDateTime)
            : 'Just now';

        print('requestReason $requestReason');

        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: SizedBox(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50], Colors.blue[50]],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      // text: riderUsername,
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: driverUsername,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        requestReason == 'addNewRoute'
                            ? TextSpan(
                                text: ' added a new route',
                              )
                            : (requestReason == 'acceptRequest'
                                ? TextSpan(
                                    text: ' accept your request',
                                  )
                                : TextSpan(
                                    text: ' reject your request',
                                  )),
                        TextSpan(
                          text: ' From ',
                        ),
                        TextSpan(
                          text: from,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' To ',
                        ),
                        TextSpan(
                          text: to,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    requestDateTimeStamp,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        //onTap:onCarTap,
      },
    );
  }
}
