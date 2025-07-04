// lib/chat/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/chat_model.dart';
import '../../../services/supabase/supabase_service.dart'; // Import your Supabase service
import 'chat_conversation_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> _chats = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedChats = await SupabaseService.getChats();
      // Fetch unread counts for each chat
      for (var chat in fetchedChats) {
        final unreadCount = await SupabaseService.getUnreadCount(chat.id);
        chat = chat.copyWith(unreadCount: unreadCount);
      }
      setState(() {
        _chats = fetchedChats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load chats: $e';
        _isLoading = false;
      });
      print('Error fetching chats in ChatListScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : _chats.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No chats yet!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start a conversation with someone new.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        // Determine the other user in the chat
                        final otherUser = chat.user1!.id == SupabaseService.currentUserId
                            ? chat.user2
                            : chat.user1;

                        if (otherUser == null) return const SizedBox.shrink();

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(otherUser.profileImage ?? ''),
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            title: Text(
                              otherUser.name,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              chat.lastMessage ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('hh:mm a').format(chat.lastMessageTime ?? DateTime.now()),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                if (chat.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${chat.unreadCount}',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatConversationScreen(
                                    chat: chat,
                                    otherUser: otherUser, // Pass the other user object
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}