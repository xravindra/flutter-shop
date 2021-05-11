import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttershop/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _exp;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_exp != null && _exp.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
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
        notifyListeners();
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
}
