import '../models/user_model.dart';

class DummyUsers {
  static final List<User> users = [
    User(
      id: 'current_user',
      name: 'You',
      username: '@you',
      bio: 'Living life to the fullest! 🌟',
      profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b2e1c8e2?w=200&h=200&fit=crop&crop=face',
      age: 25,
      location: 'San Francisco, CA',
      interests: ['Photography', 'Travel', 'Coffee'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    User(
      id: '1',
      name: 'Emma Johnson',
      username: '@emma_j',
      bio: 'Photographer & digital nomad 📸✈️',
      profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
      age: 28,
      location: 'Los Angeles, CA',
      interests: ['Photography', 'Travel', 'Art'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    User(
      id: '2',
      name: 'Alex Chen',
      username: '@alex_c',
      bio: 'Software engineer by day, chef by night 👨‍💻🍳',
      profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
      age: 26,
      location: 'Seattle, WA',
      interests: ['Technology', 'Cooking', 'Gaming'],
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    User(
      id: '3',
      name: 'Maya Patel',
      username: '@maya_p',
      bio: 'Yoga instructor & wellness coach 🧘‍♀️',
      profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face',
      age: 24,
      location: 'Austin, TX',
      interests: ['Yoga', 'Wellness', 'Nature'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    User(
      id: '4',
      name: 'David Kim',
      username: '@david_k',
      bio: 'Music producer & coffee enthusiast ☕🎵',
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
      age: 30,
      location: 'Nashville, TN',
      interests: ['Music', 'Coffee', 'Technology'],
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    User(
      id: '5',
      name: 'Sophie Martinez',
      username: '@sophie_m',
      bio: 'Marketing manager & dog lover 🐕💼',
      profileImage: 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=200&h=200&fit=crop&crop=face',
      age: 27,
      location: 'Miami, FL',
      interests: ['Marketing', 'Dogs', 'Beach'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    User(
      id: '6',
      name: 'Ryan Thompson',
      username: '@ryan_t',
      bio: 'Fitness trainer & outdoor adventurer 🏋️‍♂️🏔️',
      profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face',
      age: 29,
      location: 'Denver, CO',
      interests: ['Fitness', 'Hiking', 'Adventure'],
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    User(
      id: '7',
      name: 'Aria Williams',
      username: '@aria_w',
      bio: 'Graphic designer & plant parent 🎨🌱',
      profileImage: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&h=200&fit=crop&crop=face',
      age: 25,
      location: 'Portland, OR',
      interests: ['Design', 'Plants', 'Art'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
    User(
      id: '8',
      name: 'Jake Wilson',
      username: '@jake_w',
      bio: 'Startup founder & tech enthusiast 🚀💡',
      profileImage: 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=200&h=200&fit=crop&crop=face',
      age: 32,
      location: 'New York, NY',
      interests: ['Entrepreneurship', 'Technology', 'Innovation'],
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    User(
      id: '9',
      name: 'Luna Garcia',
      username: '@luna_g',
      bio: 'Fashion blogger & style consultant ✨👗',
      profileImage: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&h=200&fit=crop&crop=face',
      age: 26,
      location: 'Chicago, IL',
      interests: ['Fashion', 'Style', 'Photography'],
      isOnline: true,
      lastSeen: DateTime.now(),
    ),
  ];

  static User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static User get currentUser => users.first;
  
  static List<User> get otherUsers => users.skip(1).toList();
}