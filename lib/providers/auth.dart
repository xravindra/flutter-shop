import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _exp;
  String _userId;

  void _authenticate(
      String mobileNumber, String password, String action) async {
    print(mobileNumber);
    print(password);
    try {
      final urlData =
          'https://kalps-esanskar-backend.herokuapp.com/api/users/$action';
      final resp = await http.post(
        Uri.parse(urlData),
        headers: {
          'Content-Type': 'application/json',
          'mode': 'no-cors',
        },
        body: json.encode({
          'mobileNumber': mobileNumber,
          'password': password,
        }),
      );
      print(json.decode(resp.body));
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String mobileNumber, String password) {
    _authenticate(mobileNumber, password, 'login');
  }

  Future<void> signup(String mobileNumber, String password) {
    _authenticate(mobileNumber, password, 'sign-up');
  }
}
