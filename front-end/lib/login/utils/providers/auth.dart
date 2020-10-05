import 'package:flutter/material.dart';
import 'package:khedni_maak/login/utils/models/signUp_data.dart';

import '../models/login_data.dart';

enum AuthMode { SignUp, Login }

/// The result is an error message, callback successes if message is null
typedef AuthCallback = Future<String> Function(LoginData);

/// The result is an error message, callback successes if message is null
typedef AuthSignUpCallback = Future<String> Function(SignUpData);

/// The result is an error message, callback successes if message is null
typedef RecoverCallback = Future<String> Function(String);

class Auth with ChangeNotifier {
  Auth({
    this.onLogin,
    this.onSignup,
    this.onRecoverPassword,
    String email = '',
    String password = '',
    String confirmPassword = '',
    String firstName = '',
    String lastName = '',
    String phoneNumber = '',
  })  : this._email = email,
        this._password = password,
        this._confirmPassword = confirmPassword,
        this._firstName = firstName,
        this._lastName = lastName,
        this._phoneNumber = phoneNumber;

  final AuthCallback onLogin;
  final AuthSignUpCallback onSignup;
  final RecoverCallback onRecoverPassword;

  AuthMode _mode = AuthMode.Login;

  AuthMode get mode => _mode;

  set mode(AuthMode value) {
    _mode = value;
    notifyListeners();
  }

  bool get isLogin => _mode == AuthMode.Login;

  bool get isSignup => _mode == AuthMode.SignUp;
  bool isRecover = false;

  AuthMode opposite() {
    return _mode == AuthMode.Login ? AuthMode.SignUp : AuthMode.Login;
  }

  AuthMode switchAuth() {
    if (mode == AuthMode.Login) {
      mode = AuthMode.SignUp;
    } else if (mode == AuthMode.SignUp) {
      mode = AuthMode.Login;
    }
    return mode;
  }

  String _email = '';

  get email => _email;

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _password = '';

  get password => _password;

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassword = '';

  get confirmPassword => _confirmPassword;

  set confirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  String _firstName = '';

  get firstName => _firstName;

  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  String _lastName = '';

  get lastName => _lastName;

  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  String _phoneNumber = '';

  get phoneNumber => _phoneNumber;

  set phoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
}
