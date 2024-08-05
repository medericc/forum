import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Save token or set session
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    // Clear token or unset session
  }
}
