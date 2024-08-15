import 'package:flutter/material.dart';
import '../models/topic.dart';

class TopicDetailScreen extends StatelessWidget {
  final Topic topic;

  TopicDetailScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Auteur: ${topic.userId}'),
            Text('Date: ${topic.createdAt}'),
            SizedBox(height: 16.0),
            Text(
              topic.description,  // Contenu de la discussion
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32.0),
            Expanded(
              child: ListView.builder(
                itemCount: topic.replies.length,  // assuming 'replies' is a list of responses
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(topic.replies[index].author),
                      subtitle: Text(topic.replies[index].content),
                    ),
                  );
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Ajouter la logique pour envoyer une réponse
              },
              child: Text('Répondre'),
            ),
          ],
        ),
      ),
    );
  }
}
