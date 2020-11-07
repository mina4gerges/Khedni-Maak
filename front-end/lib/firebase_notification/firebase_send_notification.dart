import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';

final String serverToken = Secrets.FCMServer_Token;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future sendAndRetrieveMessage(
    String title, String body, String topicName, Map routesInfo) async {
  String toParam = topicName != null
      ? '/topics/$topicName'
      : await firebaseMessaging.getToken();

  return await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'body': body,
          "routesInfo": jsonEncode(routesInfo),
        },
        'to': toParam,
      },
    ),
  );
}
