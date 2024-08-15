import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/category.dart';
import '../models/topic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/category.dart';
import '../models/topic.dart';
import '../models/reply.dart' as reply_model;
class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000'; // Change to 10.0.2.2 for Android Emulator

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Topic>> getTopics() async {
    final response = await http.get(Uri.parse('$baseUrl/topics'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Topic.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  // Nouvelle méthode pour obtenir les topics par catégorie
  Future<List<Topic>> getTopicsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/categories/$categoryId/topics'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Topic.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load topics for category $categoryId');
    }
  }

Future<List<reply_model.Reply>> getReplies(int topicId) async {
  final response = await http.get(Uri.parse('$baseUrl/replies/$topicId'));  // Correct endpoint
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => reply_model.Reply.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load replies');
  }
}



  // New method to add a reply to a topic
  Future<void> addReply(int topicId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/topics/$topicId/replies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      print('Reply added successfully!');
    } else {
      throw Exception('Failed to add reply for topic $topicId');
    }
  }
}
