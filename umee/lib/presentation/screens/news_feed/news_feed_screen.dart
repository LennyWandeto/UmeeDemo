import 'package:flutter/material.dart';
import '../../../data/dummy_data/dummy_posts.dart';
import '../../../data/dummy_data/dummy_users.dart';
import '../../../data/models/post_model.dart';
import 'widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    posts = DummyPosts.posts;
  }

  void _likePost(String postId) {
    setState(() {
      final index = posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        posts[index] = posts[index].copyWith(
          isLiked: !posts[index].isLiked,
          likes: posts[index].isLiked 
              ? posts[index].likes - 1 
              : posts[index].likes + 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Umee',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            posts = DummyPosts.posts;
          });
        },
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final user = DummyUsers.getUserById(post.userId);
            if (user == null) return const SizedBox.shrink();
            
            return PostCard(
              post: post,
              user: user,
              onLike: () => _likePost(post.id),
              onComment: () {
                // TODO: Implement comment functionality
              },
              onShare: () {
                // TODO: Implement share functionality
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create post functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}