import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String userName;
  final String name;
  final String lastName;
  final String email;

  const User(
      {@required this.userName,
      @required this.name,
      @required this.lastName,
      @required this.email});
}
