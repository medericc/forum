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
        final responseData = json.decode(response.body);

        if (responseData['token'] != null && responseData['token'] is String) {
          String token = responseData['token'];
          String userId = responseData['user_id'].toString(); // Assurez-vous que l'API renvoie l'user_id

          // Enregistrez le token et l'user_id
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_id', userId);

          return token;
        } else {
          print('Token ou ID utilisateur manquant dans la réponse');
          return null;
        }
      } else {
        print('Échec de la connexion avec le code: ${response.statusCode}');
        print('Corps de la réponse: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Une erreur est survenue lors de la connexion: $error');
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
   Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}