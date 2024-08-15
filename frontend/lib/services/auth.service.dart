import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
static const String baseUrl = 'http://127.0.0.1:5000/api/auth';

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Sauvegarder le token ou initialiser une session
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Utilisateur enregistré avec succès
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    // Effacer le token ou mettre fin à la session
  }
}
