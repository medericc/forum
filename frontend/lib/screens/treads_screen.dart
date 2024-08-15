import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/reply.dart' as reply_model;
import '../services/api_services.dart';
import '../services/auth.service.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  TopicDetailScreen({required this.topic});

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late TextEditingController _replyController;
  late Future<List<reply_model.Reply>> futureReplies;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
    futureReplies = ApiService().getReplies(widget.topic.id);
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // Vérifiez si l'utilisateur est connecté
    bool loggedIn = await AuthService().isLoggedIn;
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _addReply() async {
    if (_replyController.text.trim().isEmpty) return;

    if (!isLoggedIn) {
      _showLoginAlert();
      return;
    }

    await ApiService().addReply(widget.topic.id, _replyController.text);
    setState(() {
      futureReplies = ApiService().getReplies(widget.topic.id); // Reload replies
    });

    _replyController.clear();
  }

  void _showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connexion requise'),
          content: Text('Vous devez être connecté pour répondre à ce sujet.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Se connecter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(widget.topic.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 16.0),
            Text('Auteur: ${widget.topic.userId}'),
            Text('Date: ${widget.topic.createdAt}'),
            SizedBox(height: 32.0),
           Expanded(
  child: FutureBuilder<List<reply_model.Reply>>(
    future: futureReplies,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Erreur: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        // Check if the list is empty
        if (snapshot.data!.isEmpty) {
          return Center(child: Text('Pas de réponses pour le moment'));
        } else {
          List<reply_model.Reply> replies = snapshot.data!;
          return ListView.builder(
            itemCount: replies.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text('Utilisateur ${replies[index].userId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(replies[index].content),
                      Text('Posté le ${replies[index].createdAt}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else {
        // Fallback case for unexpected scenarios
        return Center(child: Text('Pas de réponses pour le moment'));
      }
    },
  ),
),

            SizedBox(height: 16.0),
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addReply,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}
