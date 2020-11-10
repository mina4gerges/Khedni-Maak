import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/context/notification_provider.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/display_flash_bar.dart';
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
    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

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

      DisplayFlashBar.displayFlashBar('success', 'Request accepted', context);
    }

    _onDeclineRequest(String routeId) {
      _removeNotification(routeId);

      DisplayFlashBar.displayFlashBar('success', 'Request rejected', context);
    }

    Future<void> _openConfirmModal(
        String title, String routeId, String source) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(title),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () => {
                      Navigator.pop(context),
                      source == 'accept'
                          ? _onAcceptRequest(routeId)
                          : _onDeclineRequest(routeId),
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green[600],
                    textColor: Colors.white,
                    child: Row(
                      children: [
                        Icon(Icons.check),
                        Text("Yes"),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => {Navigator.pop(context)},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.yellow[800],
                    textColor: Colors.white,
                    child: Row(
                      children: [
                        Icon(FlevaIcons.close),
                        Text("Cancel"),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    if (notificationsRiderRequest.length == 0)
      return ErrorWidgetDisplay(
        title: 'No notifications',
        subTitle: 'Notifications are empty',
        imagePath: 'truck.png',
      );

    return AnimatedList(
      key: listKey,
      initialItemCount: notificationsRiderRequest.length,
      itemBuilder: (context, index, animation) {
        final route = notificationsRiderRequest[index];
        String from = route['from'];
        String to = route['to'];
        String riderUsername = route['riderUsername'];
        String routeId = route['routeId'];
        String requestDateTime = route['requestDateTime'];
        String requestDateTimeStamp =
            Functions.timeAgoSinceDate(requestDateTime);

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
                          text: riderUsername,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' request to join you from ',
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
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () => _openConfirmModal(
                          "Are you sure do you want to accept request ?",
                          routeId,
                          'accept',
                        ),
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
                        onPressed: () => _openConfirmModal(
                          "Are you sure do you want to reject request ?",
                          routeId,
                          'reject',
                        ),
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
                    ],
                  )
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
