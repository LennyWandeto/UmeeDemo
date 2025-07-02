class Post {
  final String id;
  final String userId;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    this.images = const [],
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? content,
    List<String>? images,
    DateTime? createdAt,
    int? likes,
    int? comments,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
}