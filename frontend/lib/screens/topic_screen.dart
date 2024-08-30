import 'package:flutter/material.dart';
import '../models/topic.dart';
import './treads_screen.dart';
import '../services/api_services.dart';
import '../services/auth.service.dart';

class TopicListScreen extends StatefulWidget {
  final int categoryId;

  TopicListScreen({required this.categoryId});

  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late Future<List<Topic>> futureTopics;
  bool isLoggedIn = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    futureTopics = ApiService().getTopicsByCategory(widget.categoryId).then((topics) {
      return topics ?? []; // Retourner une liste vide si 'topics' est null
    });
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  void _checkLoginStatus() async {
    isLoggedIn = await AuthService().isLoggedIn;
    userId = await AuthService().getUserId();
    setState(() {});
  }

  // Méthode pour supprimer un sujet
  void _deleteTopic(int topicId) async {
    if (userId != null) {  // Vérifier que le userId est défini
      try {
        await ApiService().deleteTopic(topicId, int.parse(userId!));  // Passer les deux arguments ici
        setState(() {
          futureTopics = ApiService().getTopicsByCategory(widget.categoryId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sujet supprimé avec succès.'),
        ));
      } catch (error) {
        print('Failed to delete topic: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la suppression du sujet. Veuillez réessayer.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des sujets'),
      ),
      body: FutureBuilder<List<Topic>>(
        future: futureTopics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Topic> topics = snapshot.data!;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      topic.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auteur: ${topic.userId}'),
                        Text('Date: ${topic.createdAt}'),
                      ],
                    ),
        trailing: isLoggedIn && topic.userId.toString() == userId
    ? IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteTopic(topic.id),
      )
    : null,
onTap: () {
  print('Topic User ID: ${topic.userId}, Logged in User ID: $userId, isLoggedIn: $isLoggedIn');
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TopicDetailScreen(topic: topic),
    ),
  );
},


                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Aucun sujet trouvé'));
          }
        },
      ),
    );
  }
}
