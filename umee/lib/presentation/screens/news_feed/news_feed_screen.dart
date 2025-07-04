import 'package:flutter/material.dart';
import 'package:umee/presentation/screens/news_feed/create_post_screen.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/user_model.dart'; // Make sure this import is correct
import '../../../services/supabase/supabase_service.dart'; // Import your Supabase service
import 'widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<Post> posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedPosts = await SupabaseService.getPosts();
      setState(() {
        posts = fetchedPosts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load posts: $e';
        _isLoading = false;
      });
      print('Error fetching posts in NewsFeedScreen: $e');
    }
  }

  void _likePost(int postId) async {
    // Optimistic UI update
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

    try {
      final success = await SupabaseService.toggleLike(postId);
      if (!success) {
        // Revert if API call fails
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update like status.')),
        );
      }
    } catch (e) {
      // Revert on error
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error toggling like.')),
      );
      print('Error toggling like: $e');
    }
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
            onPressed: () {
              // TODO: Implement notification functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPosts,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(_errorMessage!),
                  )
                : posts.isEmpty
                    ? const Center(child: Text('No posts available.'))
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          // Supabase already fetches user info with the post,
                          // so we can cast directly.
                          final User user = post.user!;

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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
          // If a post was successfully created, refresh the news feed
          if (result == true) {
            _fetchPosts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}