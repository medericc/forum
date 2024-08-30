import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/category.dart';
import '../models/topic.dart';
import '../models/reply.dart' as reply_model;
class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000'; 

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



Future<void> addReply(int topicId, int userId, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reply'),  // Changement de 'replies' à 'reply'
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'topic_id': topicId,
        'user_id': userId,
        'description': description,  
      }),
    );

    if (response.statusCode == 201) {
      print('Reply added successfully!');
    } else {
      print('Failed to add reply: ${response.statusCode}');
      throw Exception('Failed to add reply');
    }
}

 // Méthode pour supprimer un sujet
Future<void> deleteTopic(int topicId, int userId) async {
  // Log les paramètres d'entrée
  print('deleteTopic called with topicId: $topicId, userId: $userId');

  try {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/topics/$topicId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'user_id': userId,
      }),
    );

    // Log la réponse du serveur
    print('Server response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Topic deleted successfully!');
    } else {
      print('Failed to delete topic: ${response.statusCode}');
      throw Exception('Failed to delete topic');
    }
  } catch (e) {
    // Log en cas d'exception
    print('Error occurred while deleting topic: $e');
    throw Exception('Error occurred while deleting topic');
  }
}

  // Méthode pour supprimer une réponse
  Future<void> deleteReply(int replyId, int userId) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/api/replies/$replyId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'user_id': userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete reply');
    }
  }
  
}
