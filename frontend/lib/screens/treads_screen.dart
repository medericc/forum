import 'package:flutter/material.dart';
import '../models/topic.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  TopicDetailScreen({required this.topic});

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  late TextEditingController _replyController;
  late List<Reply> _replies;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
    _replies = List.from(widget.topic.replies); // Copie locale des réponses existantes
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _addReply() {
    if (_replyController.text.trim().isEmpty) return;

    final newReply = Reply(
      author: 'Utilisateur',  // Vous pouvez adapter pour obtenir l'utilisateur courant
      content: _replyController.text,
    );

    setState(() {
      _replies.add(newReply);  // Ajouter la nouvelle réponse à la liste
    });

    _replyController.clear();  // Effacer le champ de texte après l'envoi
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
              child: _replies.isEmpty
                  ? Center(child: Text('Pas de réponses pour le moment'))
                  : ListView.builder(
                      itemCount: _replies.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(_replies[index].author),
                            subtitle: Text(_replies[index].content),
                          ),
                        );
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
