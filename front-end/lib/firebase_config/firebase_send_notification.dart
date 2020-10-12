import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'file:///C:/Users/mina.gerges/Desktop/Mobile%20Apps/Khedni-Maak/front-end/lib/config/Secrets.dart';

final String serverToken = Secrets.FCMServer_Token;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future sendAndRetrieveMessage(String title,String body) async {
  return await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': title,
          'title': body
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          // 'body': title,
          // 'title': body
        },
        'to': await firebaseMessaging.getToken(),
      },
    ),
  );
}
