class Reply {
  final int id;
  final int userId;
  final String description;
  final DateTime createdAt;

  Reply({required this.id, required this.userId, required this.description, required this.createdAt});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
