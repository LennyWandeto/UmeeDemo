// lib/screens/news_feed/create_post_screen.dart
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:umee/data/models/post_model.dart'; // Ensure correct path to your Post model
import 'package:umee/services/supabase/supabase_service.dart'; // Import your Supabase service

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool _isPosting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post content cannot be empty!')),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      // For now, we'll send an empty list for images.
      // Image upload would involve Supabase Storage and more complex logic.
      final Post? newPost = await SupabaseService.createPost(
        content: _contentController.text.trim(),
        images: [], // Placeholder for image URLs
      );

      if (newPost != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post created successfully!')),
          );
          Navigator.pop(context, true); // Pop with true to indicate success
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create post. Please try again.')),
          );
        }
      }
    } catch (e) {
      print('Error creating post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        actions: [
          _isPosting
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : TextButton(
                  onPressed: _createPost,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blue, // Or your primary color
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              maxLines: null, // Allows multiline input
              minLines: 5,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.all(16),
              ),
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            // TODO: Add functionality for image selection here
            // Example placeholder for an image picker button
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Implement image picking logic here
            //   },
            //   icon: const Icon(Icons.image),
            //   label: const Text('Add Image'),
            // ),
          ],
        ),
      ),
    );
  }
}