// lib/data/dummy_data.dart
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart'; // Adjust path if chat_model.dart is elsewhere

class DummyData {
  static const String currentUserId = 'user_123';
  static const String currentUserName = 'Emma Johnson';
  static const String currentUserProfilePic = 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=200&h=200&fit=crop&crop=face';

  // Initialize Uuid once
  static final Uuid _uuid = const Uuid();

  // Dummy chat data
  static final List<Chat> dummyChats = [
    Chat(
      id: _uuid.v4(),
      userId1: currentUserId,
      userId2: 'user_456',
      lastMessage: 'Hey, how are you doing?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    Chat(
      id: _uuid.v4(),
      userId1: currentUserId,
      userId2: 'user_789',
      lastMessage: 'Let\'s catch up soon!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
    ),
    Chat(
      id: _uuid.v4(),
      userId1: currentUserId,
      userId2: 'user_012',
      lastMessage: 'Did you see the news feed post?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
    ),
  ];

  // Dummy message data for specific chats
  // Using a late final map and initializing it based on dummyChats
  static late final Map<String, List<Message>> dummyMessages = _initializeDummyMessages();

  static Map<String, List<Message>> _initializeDummyMessages() {
    return {
      // Messages for chat between user_123 and user_456 (using the actual ID from dummyChats)
      dummyChats[0].id: [
        Message(
          id: _uuid.v4(),
          chatId: dummyChats[0].id,
          senderId: 'user_456',
          content: 'Hi John!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10, seconds: 30)),
        ),
        Message(
          id: _uuid.v4(),
          chatId: dummyChats[0].id,
          senderId: currentUserId,
          content: 'Hey, how are you doing?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        Message(
          id: _uuid.v4(),
          chatId: dummyChats[0].id,
          senderId: 'user_456',
          content: 'I\'m good, thanks! How about you?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ],
      // Messages for chat between user_123 and user_789 (using the actual ID from dummyChats)
      dummyChats[1].id: [
        Message(
          id: _uuid.v4(),
          chatId: dummyChats[1].id,
          senderId: 'user_789',
          content: 'Hey, long time no see!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Message(
          id: _uuid.v4(),
          chatId: dummyChats[1].id,
          senderId: currentUserId,
          content: 'Yeah! Let\'s catch up soon!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
      // Add more chat messages as needed for other chats in dummyChats
    };
  }

  static final Map<String, String> dummyUserNames = {
    currentUserId: currentUserName,
    'user_456': 'Jane Smith',
    'user_789': 'Peter Jones',
    'user_012': 'Alice Brown',
  };

  static final Map<String, String> dummyUserProfilePics = {
    currentUserId: currentUserProfilePic,
    'user_456': 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=200&h=200&fit=crop&crop=face',
    'user_789': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face',
    'user_012': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
  };
}