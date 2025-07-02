// lib/chat/chat_conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/chat_model.dart'; // Adjust path if chat_model.dart is elsewhere

class ChatConversationScreen extends StatefulWidget {
  final Chat chat;
  final String currentUserId;
  final String otherUserName;
  final String otherUserProfilePic;
  final List<Message> dummyMessages;
  final Map<String, String> dummyUserNames;
  final Map<String, String> dummyUserProfilePics;

  const ChatConversationScreen({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.otherUserName,
    required this.otherUserProfilePic,
    required this.dummyMessages,
    required this.dummyUserNames,
    required this.dummyUserProfilePics,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.dummyMessages); // Create a mutable copy
    // Sort messages by timestamp to ensure correct order
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final newMessage = Message(
        id: const Uuid().v4(),
        chatId: widget.chat.id,
        senderId: widget.currentUserId,
        content: _messageController.text,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
      });
      // In a real app, you would send this message to a backend/database
      // For this demo, we just add it to the local list.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.otherUserProfilePic),
            ),
            const SizedBox(width: 10),
            Text(widget.otherUserName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == widget.currentUserId;
                final senderName = widget.dummyUserNames[message.senderId] ?? 'Unknown';
                // final senderProfilePic = widget.dummyUserProfilePics[message.senderId] ?? 'https://placehold.co/150x150/CCCCCC/000000?text=NA';

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isMe) // Show sender name for messages not from current user
                          Text(
                            senderName,
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        Text(
                          message.content,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}