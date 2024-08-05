import 'package:flutter/material.dart';
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
              : IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () async {
                    bool result = await AuthService().login('username', 'password');
                    if (result) {
                      setState(() {
                        isLoggedIn = true;
                      });
                    }
                  },
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
              child: Text('Générale'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicListScreen(categoryId: 2)),
                );
              },
              child: Text('Réseaux'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicListScreen(categoryId: 3)),
                );
              },
              child: Text('Précis'),
            ),
          ],
        ),
      ),
    );
  }
}