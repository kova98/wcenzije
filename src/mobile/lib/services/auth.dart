import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wcenzije/models/token.dart';

import '../config.dart';

class AuthService {
  final String _root = Config().apiRoot + "/auth";
  final _storageKey = "wcenzije_auth_token";
  final _storage = FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    return await _storage.read(key: _storageKey);
  }

  Future<bool> isAuthorized() async {
    String? authToken = await getAuthToken();
    if (authToken == null) {
      return false;
    }

    return true;
  }

  Future<bool> login(String name, String password) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };

    final body = jsonEncode({
      "Username": name,
      "Password": password,
    });

    final response = await http.post(
      Uri.parse("$_root/login"),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      return false;
    }

    final token = Token.fromJson(json.decode(response.body));

    await _storage.write(key: _storageKey, value: token.value);
    return true;
  }

  Future<int> register(String email, String name, String password) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    };

    final body = jsonEncode({
      "Email": email,
      "Username": name,
      "Password": password,
    });

    final response = await http.post(
      Uri.parse("$_root/register"),
      headers: headers,
      body: body,
    );

    return response.statusCode;
  }

  Future logout() async {
    await _storage.delete(key: _storageKey);
  }
}
