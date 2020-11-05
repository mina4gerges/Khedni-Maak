import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';

final String serverToken = Secrets.FCMServer_Token;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future sendAndRetrieveMessage(String title, String body, String topicName,
    String routeId) async {
  String toParam = topicName != null
      ? '/topics/$topicName'
      : await firebaseMessaging.getToken();

  print("notification param $toParam");

  return await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': title, 'title': body},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'body': title,
          'title': body,
          "routeId":routeId
        },
        'to': toParam,
      },
    ),
  );
}
