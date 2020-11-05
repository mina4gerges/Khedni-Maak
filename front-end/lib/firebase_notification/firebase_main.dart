import 'package:flutter/material.dart';

import 'firebase_messaging_widget.dart';
import 'firebase_send_notification.dart';

class FireBaseMain extends StatelessWidget {
  final String appTitle;

  const FireBaseMain({this.appTitle});

  void sentNotification() {
    sendAndRetrieveMessage("test title", "test body", null,null).then((value) => {
          if (value.statusCode == 200)
            {
              print("notification sent successfully"),
            }
          else
            {
              print('failed to sent notification'),
            }
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MessagingWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            sentNotification();
          },
          child: Icon(Icons.notifications),
          backgroundColor: Colors.green,
        ),
      );
}
