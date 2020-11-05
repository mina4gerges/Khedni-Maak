import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String name;
  final String email;
  final String fullName;
  final String userName;
  final String lastName;
  final String phoneNumber;

  const User({
    @required this.name,
    @required this.email,
    @required this.userName,
    @required this.fullName,
    @required this.lastName,
    @required this.phoneNumber,
  });
}
