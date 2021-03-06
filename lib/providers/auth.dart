import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

const API_KEY = 'AIzaSyCiHjmtLoLHWgp6FBv1LnR73YXEscetSUY';
const API_URL = 'identitytoolkit.googleapis.com';
const API_SIGNIN_URN = '/v1/accounts:signInWithPassword';
const API_SIGNUP_URN = '/v1/accounts:signUp';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urn) async {
    final uri = Uri.https(API_URL, urn, {
      'key': API_KEY,
    });
    try {
      final response = await http.post(
        uri,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, API_SIGNUP_URN);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, API_SIGNIN_URN);
  }
}
