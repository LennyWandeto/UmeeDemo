// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/user_model.dart' as user_model;
import '../../../data/models/post_model.dart';
import '../../../data/models/chat_model.dart';

class SupabaseService {
  static const String currentUserId = 'user_123'; // Emma Johnson
  static final SupabaseClient _client = Supabase.instance.client;

  // Get current user
  static Future<user_model.User?> getCurrentUser() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', currentUserId)
          .single();
      
      return user_model.User.fromJson(response);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get all users
  static Future<List<user_model.User>> getUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .order('name');
      
      return (response as List)
          .map<user_model.User>((user) => user_model.User.fromJson(user as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  // Get user by ID
  static Future<user_model.User?> getUserById(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return user_model.User.fromJson(response);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  // Get posts with user information and like status
  static Future<List<Post>> getPosts() async {
    try {
      // Get posts with user information
      final response = await _client
          .from('posts')
          .select('''
            *,
            users!posts_user_id_fkey (
              id,
              name,
              username,
              profile_image
            )
          ''')
          .order('created_at', ascending: false);

      // Get current user's likes
      final likesResponse = await _client
          .from('user_post_likes')
          .select('post_id')
          .eq('user_id', currentUserId);

      final likedPostIds = Set<int>.from(
        (likesResponse as List).map((like) => like['post_id'] as int)
      );

      return (response as List).map((postData) {
        final post = Post.fromJson(postData);
        return post.copyWith(isLiked: likedPostIds.contains(post.id));
      }).toList();
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  // Get chats for current user
  static Future<List<Chat>> getChats() async {
    try {
      final response = await _client
          .from('chats')
          .select('''
            *,
            user1:users!chats_user1_id_fkey (
              id,
              name,
              username,
              profile_image
            ),
            user2:users!chats_user2_id_fkey (
              id,
              name,
              username,
              profile_image
            )
          ''')
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
          .order('last_message_time', ascending: false);

      return (response as List)
          .map((chat) => Chat.fromJson(chat))
          .toList();
    } catch (e) {
      print('Error getting chats: $e');
      return [];
    }
  }

  // Get messages for a specific chat
  static Future<List<Message>> getMessages(String chatId) async {
    try {
      final response = await _client
          .from('messages')
          .select('''
            *,
            sender:users!messages_sender_id_fkey (
              id,
              name,
              username,
              profile_image
            )
          ''')
          .eq('chat_id', chatId)
          .order('timestamp', ascending: true);

      return (response as List)
          .map((message) => Message.fromJson(message))
          .toList();
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  // Get unread message count for a chat
  static Future<int> getUnreadCount(String chatId) async {
    try {
      // For demo purposes, we'll simulate unread count
      // In a real app, you'd track read/unread status
      final messages = await getMessages(chatId);
      return messages
          .where((msg) => msg.senderId != currentUserId)
          .length > 0 ? 1 : 0;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Toggle like on a post
  static Future<bool> toggleLike(int postId) async {
    try {
      // Check if already liked
      final existingLike = await _client
          .from('user_post_likes')
          .select()
          .eq('user_id', currentUserId)
          .eq('post_id', postId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike - the trigger will automatically update the count
        await _client
            .from('user_post_likes')
            .delete()
            .eq('user_id', currentUserId)
            .eq('post_id', postId);
        
        return false;
      } else {
        // Like - the trigger will automatically update the count
        await _client
            .from('user_post_likes')
            .insert({
              'user_id': currentUserId,
              'post_id': postId,
            });
        
        return true;
      }
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  // Send a message
  static Future<Message?> sendMessage(String chatId, String content) async {
    try {
      final response = await _client
          .from('messages')
          .insert({
            'chat_id': chatId,
            'sender_id': currentUserId,
            'content': content,
          })
          .select('''
            *,
            sender:users!messages_sender_id_fkey (
              id,
              name,
              username,
              profile_image
            )
          ''')
          .single();

      // Update chat's last message
      await _client
          .from('chats')
          .update({
            'last_message': content,
            'last_message_time': DateTime.now().toIso8601String(),
          })
          .eq('id', chatId);

      return Message.fromJson(response);
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  static Future<Post?> createPost({
    required String content,
    List<String>? images,
  }) async {
    try {
      final response = await _client
          .from('posts')
          .insert({
            'user_id': currentUserId,
            'content': content,
            'images': images ?? [],
            'likes': 0, // Initial likes
            'comments': 0, // Initial comments
            // 'created_at' will be set by the database default
          })
          .select('''
            *,
            users!posts_user_id_fkey (
              id,
              name,
              username,
              profile_image
            )
          ''') // Select the newly created post with user info
          .single();

      return Post.fromJson(response);
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }
}

// You'll also need to create a SQL function for incrementing likes
// Run this in your Supabase SQL editor:
/*
CREATE OR REPLACE FUNCTION increment_post_likes(post_id TEXT)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE posts 
  SET likes = likes + 1 
  WHERE id = post_id;
END;
$$;
*/