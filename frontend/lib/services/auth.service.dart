import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  static const String baseUrl = 'http://127.0.0.1:5000/api/auth';

Future<String?> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Extract the token from the response
      final responseData = json.decode(response.body);

      if (responseData['token'] != null && responseData['token'] is String) {
        String token = responseData['token'];

        // Save the token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        return token;
      } else {
        print('Token is missing or invalid in the response');
        return null;
      }
    } else {
      // Handle unsuccessful login attempt
      print('Login failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (error) {
    // Handle any other errors
    print('An error occurred during login: $error');
    return null;
  }
}



  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
   Future<bool> get isLoggedIn async {
    // Check if there is a valid token stored
    String? token = await getToken();
    return token != null;
  }
}