// lib/models/post_model.dart
import 'user_model.dart';
class Post {
  final int id;
  final String userId;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isLiked;
  final User? user; // User information from join

  Post({
    required this.id,
    required this.userId,
    required this.content,
    this.images = const [],
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      createdAt: DateTime.parse(json['created_at']),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      user: json['users'] != null ? User.fromJson(json['users']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'is_liked': isLiked,
      'users': user?.toJson(),
    };
  }

  Post copyWith({
    int? id,
    String? userId,
    String? content,
    List<String>? images,
    DateTime? createdAt,
    int? likes,
    int? comments,
    bool? isLiked,
    User? user,
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
      user: user ?? this.user,
    );
  }
}