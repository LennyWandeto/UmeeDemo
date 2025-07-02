class User {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String profileImage;
  final int age;
  final String location;
  final List<String> interests;
  final bool isOnline;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.profileImage,
    required this.age,
    required this.location,
    required this.interests,
    this.isOnline = false,
    required this.lastSeen,
  });

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
    );
  }
}