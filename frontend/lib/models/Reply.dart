class Reply {
  final int id;
  final int userId;
  final String content;
  final DateTime createdAt;

  Reply({required this.id, required this.userId, required this.content, required this.createdAt});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
