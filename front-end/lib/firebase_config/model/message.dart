import 'package:flutter/cupertino.dart';

@immutable
class Message {
  final String title;
  final String body;

  const Message({@required this.title, @required this.body});
}
