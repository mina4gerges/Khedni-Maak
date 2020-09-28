import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

class SignUpData {
  final String name;
  final String password;
  final String lastName;
  final String firstName;
  final String phoneNumber;

  SignUpData({
    @required this.name,
    @required this.lastName,
    @required this.password,
    @required this.firstName,
    @required this.phoneNumber,
  });

  @override
  String toString() {
    return '$runtimeType($firstName, $lastName,$name, $password,$phoneNumber)';
  }

  bool operator ==(Object other) {
    if (other is SignUpData) {
      return name == other.name && password == other.password;
    }
    return false;
  }

  int get hashCode => hash2(name, password);
}
