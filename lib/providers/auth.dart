import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttershop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _exp;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_exp != null && _exp.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  void _authenticate(
      String mobileNumber, String password, String action) async {
    try {
      final urlData =
          'https://kalps-esanskar-backend.herokuapp.com/api/users/$action';
      final resp = await http.post(
        Uri.parse(urlData),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'mobileNumber': mobileNumber,
          'password': password,
          'confirmPassword': password,
        }),
      );
      final responseData = json.decode(resp.body);
      if (true) {
        _token = responseData['data']['token'];
        _userId = responseData['data']['userId'];
        _exp = DateTime.now().add(
          Duration(
            // seconds: responseData['expiresIn'],
            seconds: 10000,
          ),
        );
        print(responseData);
        _autoLogout();
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
            {'token': _token, 'userId': _userId, 'exp': _exp.toString()});
        prefs.setString('userData', userData);
      } else {
        throw HttpException(responseData['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String mobileNumber, String password) async {
    return _authenticate(mobileNumber, password, 'login');
  }

  Future<void> signup(String mobileNumber, String password) async {
    return _authenticate(mobileNumber, password, 'sign-up');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['exp']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _exp = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _exp = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _exp.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
