// lib/chat/chat_conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/user_model.dart'; // Import user_model for the otherUser object
import '../../../services/supabase/supabase_service.dart'; // Import your Supabase service

class ChatConversationScreen extends StatefulWidget {
  final Chat chat;
  final User otherUser; // The other user in this chat

  const ChatConversationScreen({
    super.key,
    required this.chat,
    required this.otherUser,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedMessages = await SupabaseService.getMessages(widget.chat.id);
      setState(() {
        _messages = fetchedMessages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load messages: $e';
        _isLoading = false;
      });
      print('Error fetching messages in ChatConversationScreen: $e');
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final messageContent = _messageController.text;
      _messageController.clear(); // Clear input immediately

      // Optimistic UI update: Add message to list immediately
      // The sender information will be populated correctly from the Supabase response
      final tempMessage = Message(
        id: 'temp_${DateTime.now().microsecondsSinceEpoch}', // Temporary ID
        chatId: widget.chat.id,
        senderId: SupabaseService.currentUserId,
        content: messageContent,
        timestamp: DateTime.now(),
        sender:
            await SupabaseService.getCurrentUser(), // Fetch current user for optimistic UI
      );

      setState(() {
        _messages.add(tempMessage);
      });

      try {
        final sentMessage = await SupabaseService.sendMessage(
          widget.chat.id,
          messageContent,
        );

        if (sentMessage != null) {
          // Replace temporary message with actual message from DB if needed, or just refresh
          setState(() {
            _messages[_messages.indexOf(tempMessage)] = sentMessage;
            _messages.sort(
              (a, b) => a.timestamp.compareTo(b.timestamp),
            ); // Re-sort to ensure order
          });
        } else {
          // Revert if sending failed
          setState(() {
            _messages.remove(tempMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send message.')),
          );
        }
      } catch (e) {
        // Revert on error
        setState(() {
          _messages.remove(tempMessage);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error sending message.')));
        print('Error sending message: $e');
      }
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
              backgroundImage: NetworkImage(
                widget.otherUser.profileImage ?? '',
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.otherUser.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : _messages.isEmpty
                    ? const Center(child: Text('Start a conversation!'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe =
                            message.senderId == SupabaseService.currentUserId;
                        final sender =
                            message
                                .sender; // Access sender directly from message model

                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isMe
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft:
                                    isMe
                                        ? const Radius.circular(12)
                                        : const Radius.circular(0),
                                bottomRight:
                                    isMe
                                        ? const Radius.circular(0)
                                        : const Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                if (!isMe &&
                                    sender !=
                                        null) // Show sender name for messages not from current user
                                  Text(
                                    sender.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                Text(
                                  message.content,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'hh:mm a',
                                  ).format(message.timestamp),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
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
