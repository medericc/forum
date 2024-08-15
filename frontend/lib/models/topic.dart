class Reply {
  final String author;
  final String content;

  Reply({required this.author, required this.content});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      author: json['author'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
    };
  }
}

class Topic {
  final int id;
  final String title;
  final String description;
  final int userId; // Correspond à l'auteur
  final String createdAt;
  final List<Reply> replies; // Liste des réponses

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.replies,
  });

factory Topic.fromJson(Map<String, dynamic> json) {
    var list = json['replies'] as List?;
    List<Reply> repliesList = list != null 
        ? list.map((i) => Reply.fromJson(i)).toList() 
        : [];

    return Topic(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      replies: repliesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': userId,
      'created_at': createdAt,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}
