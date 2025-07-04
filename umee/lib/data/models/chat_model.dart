// lib/models/chat_model.dart
import 'user_model.dart';
class Chat {
  final String id;
  final String userId1;
  final String userId2;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime? createdAt;
  final User? user1; // User information from join
  final User? user2; // User information from join

  Chat({
    required this.id,
    required this.userId1,
    required this.userId2,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.createdAt,
    this.user1,
    this.user2,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId1: json['user1_id'],
      userId2: json['user2_id'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null 
          ? DateTime.parse(json['last_message_time']) 
          : null,
      unreadCount: json['unread_count'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      user1: json['user1'] != null ? User.fromJson(json['user1']) : null,
      user2: json['user2'] != null ? User.fromJson(json['user2']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': userId1,
      'user2_id': userId2,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'unread_count': unreadCount,
      'created_at': createdAt?.toIso8601String(),
      'user1': user1?.toJson(),
      'user2': user2?.toJson(),
    };
  }

  // Get the other user in the chat (not the current user)
  User? getOtherUser(String currentUserId) {
    if (userId1 == currentUserId) {
      return user2;
    } else {
      return user1;
    }
  }

  Chat copyWith({
    String? id,
    String? userId1,
    String? userId2,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    DateTime? createdAt,
    User? user1,
    User? user2,
  }) {
    return Chat(
      id: id ?? this.id,
      userId1: userId1 ?? this.userId1,
      userId2: userId2 ?? this.userId2,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
    );
  }
}

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final User? sender; // Sender information from join

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender?.toJson(),
    };
  }

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    DateTime? timestamp,
    User? sender,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
    );
  }
}