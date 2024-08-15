import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'user_list_screen.dart';
import 'topic_screen.dart';
import 'category_screen.dart';
import '../services/auth.service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Chrétien'),
        actions: [
          isLoggedIn
              ? IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    AuthService().logout();
                    setState(() {
                      isLoggedIn = false;
                    });
                  },
                )
              : Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.login),
                      onPressed: () {
                        _showLoginDialog(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        _showRegisterDialog(context);
                      },
                    ),
                  ],
                ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicListScreen(categoryId: 1)),
                );
              },
              child: Text('Discussions'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicListScreen(categoryId: 2)),
                );
              },
              child: Text('Bible'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicListScreen(categoryId: 3)),
                );
              },
              child: Text('Vos Réseaux'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () {
                _showCreateTopicDialog(context);
              },
              icon: Icon(Icons.add),
              label: Text('Créer une discussion'),
            ),
          ],
        ),
      ),
    );
  }

  // Login dialog
  void _showLoginDialog(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connexion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await AuthService().login(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (success) {
                  setState(() {
                    isLoggedIn = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Display an error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Échec de la connexion. Veuillez réessayer.'),
                  ));
                }
              },
              child: Text('Connexion'),
            ),
          ],
        );
      },
    );
  }

  // Register dialog
  void _showRegisterDialog(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inscription'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await _registerUser(
                  _usernameController.text,
                  _passwordController.text,
                );
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Inscription réussie. Veuillez vous connecter.'),
                  ));
                } else {
                  // Display an error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Échec de l\'inscription. Veuillez réessayer.'),
                  ));
                }
              },
              child: Text('Inscription'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    return response.statusCode == 201;
  }

  void _showCreateTopicDialog(BuildContext context) {
    final TextEditingController _topicTitleController = TextEditingController();
    final TextEditingController _topicContentController = TextEditingController();
    int _selectedCategoryId = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Créer une nouvelle discussion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _topicTitleController,
                decoration: InputDecoration(
                  labelText: 'Titre de la discussion',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _topicContentController,
                decoration: InputDecoration(
                  labelText: 'Contenu de la discussion',
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedCategoryId = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem(value: 1, child: Text('Discussions')),
                  DropdownMenuItem(value: 2, child: Text('Bible')),
                  DropdownMenuItem(value: 3, child: Text('Vos Réseaux')),
                ],
                decoration: InputDecoration(
                  labelText: 'Choisir une catégorie',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                String topicTitle = _topicTitleController.text;
                String topicContent = _topicContentController.text;
                bool success = await _createTopic(topicTitle, topicContent, _selectedCategoryId);
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  // Handle the error, e.g., show an error message
                }
              },
              child: Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _createTopic(String title, String description, int categoryId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/topics'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'category_id': categoryId,
      }),
    );

    return response.statusCode == 201;
  }
}
