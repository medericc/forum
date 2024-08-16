import 'package:flutter/material.dart';
import '../models/topic.dart';
  // Chemin vers votre fichier où 'TopicDetailScreen' est défini
import "./treads_screen.dart";

import '../services/api_services.dart';

class TopicListScreen extends StatefulWidget {
  final int categoryId;

  TopicListScreen({required this.categoryId});

  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late Future<List<Topic>> futureTopics;

 @override
void initState() {
  super.initState();
  futureTopics = ApiService().getTopicsByCategory(widget.categoryId).then((topics) {
    if (topics == null) {
      return []; // Return an empty list if topics is null
    }
    return topics;
  });
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
                
            return Card(
  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  elevation: 4.0,
  child: ListTile(
    title: Text(
      topics[index].title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Auteur: ${topics[index].userId}'),  // Affiche l'ID de l'utilisateur (auteur)
        Text('Date: ${topics[index].createdAt}'), // Affiche la date de création du topic
        SizedBox(height: 8.0),  // Ajoute un espace entre les informations de base et la description
        Text(
          topics[index].description,  // Affiche la description du sujet
          maxLines: 2,  // Limite la description à 2 lignes
          overflow: TextOverflow.ellipsis,  // Ajoute des points de suspension si le texte dépasse la limite
          style: TextStyle(color: Colors.grey[700]),  // Change la couleur du texte de la description
        ),
      ],
    ),
    onTap: () {
      // Naviguer vers l'écran de détail du sujet (TopicDetailScreen)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopicDetailScreen(topic: topics[index]),
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
