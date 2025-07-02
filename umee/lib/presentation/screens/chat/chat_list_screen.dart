// lib/chat/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/chat_model.dart'; // Adjust path if chat_model.dart is elsewhere
import '../../../data/dummy_data/dummy_chats.dart'; // Import dummy data
import 'chat_conversation_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access dummy data directly from DummyData class
    final String currentUserId = DummyData.currentUserId;
    final List<Chat> dummyChats = DummyData.dummyChats;
    final Map<String, List<Message>> dummyMessages = DummyData.dummyMessages;
    final Map<String, String> dummyUserNames = DummyData.dummyUserNames;
    final Map<String, String> dummyUserProfilePics = DummyData.dummyUserProfilePics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: dummyChats.length,
        itemBuilder: (context, index) {
          final chat = dummyChats[index];
          // Determine the other user's ID in the chat
          final otherUserId = chat.userId1 == currentUserId ? chat.userId2 : chat.userId1;
          final otherUserName = dummyUserNames[otherUserId] ?? 'Unknown User';
          final otherUserProfilePic = dummyUserProfilePics[otherUserId] ?? 'https://placehold.co/150x150/CCCCCC/000000?text=NA';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(otherUserProfilePic),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              title: Text(
                otherUserName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                chat.lastMessage,
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
                    DateFormat('hh:mm a').format(chat.lastMessageTime),
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
                      currentUserId: currentUserId,
                      otherUserName: otherUserName,
                      otherUserProfilePic: otherUserProfilePic,
                      dummyMessages: dummyMessages[chat.id] ?? [], // Pass messages for this chat
                      dummyUserNames: dummyUserNames,
                      dummyUserProfilePics: dummyUserProfilePics,
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