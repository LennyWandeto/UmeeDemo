// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String username;
  final String? bio;
  final String? profileImage;
  final int? age;
  final String? location;
  final List<String> interests;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.bio,
    this.profileImage,
    this.age,
    this.location,
    this.interests = const [],
    this.isOnline = false,
    this.lastSeen,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      profileImage: json['profile_image'],
      age: json['age'],
      location: json['location'],
      interests: json['interests'] != null 
          ? List<String>.from(json['interests']) 
          : [],
      isOnline: json['is_online'] ?? false,
      lastSeen: json['last_seen'] != null 
          ? DateTime.parse(json['last_seen']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'profile_image': profileImage,
      'age': age,
      'location': location,
      'interests': interests,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? bio,
    String? profileImage,
    int? age,
    String? location,
    List<String>? interests,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      age: age ?? this.age,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}