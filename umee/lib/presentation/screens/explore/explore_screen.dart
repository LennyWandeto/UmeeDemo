import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../../../services/supabase/supabase_service.dart'; // Import your Supabase service
import 'widgets/swipe_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<User> users = [];
  int currentIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final fetchedUsers = await SupabaseService.getUsers();
      setState(() {
        users = fetchedUsers;
        _isLoading = false;
        currentIndex = 0; // Reset index when new users are fetched
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
        _isLoading = false;
      });
      print('Error fetching users in ExploreScreen: $e');
    }
  }

  void _onSwipe(bool isLike) {
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
      
      // In a real app, you'd record the like/dislike in your backend here.
      // For this dummy setup, we're just advancing the card.
      if (isLike) {
        // You might want to implement a match logic here if applicable
        // For now, let's just show a simulated match dialog for some likes.
        if (users[currentIndex - 1].id == 'user_456' || users[currentIndex - 1].id == 'user_012') { // Example for a "match"
           _showMatchDialog(users[currentIndex - 1]);
        }
      }
    } else {
      _showNoMoreUsersDialog();
    }
  }

  void _showMatchDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border,
              color: Colors.red,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              'You two connected!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You and ${user.name} connected with each other in the Florida Fitness Center',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Keep Swiping'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to chat with 'user'
                    },
                    child: const Text('Say Hi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNoMoreUsersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No More Users'),
        content: const Text('You\'ve seen all available users. Check back later for more!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Option to re-fetch or reset if needed
              _fetchUsers();
            },
            child: const Text('Start Over / Refresh'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filters
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : users.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No users available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Check back later or adjust your filters!',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _fetchUsers,
                            child: const Text('Refresh Users'),
                          ),
                        ],
                      ),
                    )
                  : currentIndex < users.length
                      ? Stack(
                          children: [
                            // Background cards
                            if (currentIndex + 2 < users.length)
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SwipeCard(
                                    user: users[currentIndex + 2],
                                    onSwipe: (_) {},
                                    isBackground: true,
                                  ),
                                ),
                              ),
                            if (currentIndex + 1 < users.length)
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: SwipeCard(
                                    user: users[currentIndex + 1],
                                    onSwipe: (_) {},
                                    isBackground: true,
                                  ),
                                ),
                              ),
                            // Active card
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SwipeCard(
                                  user: users[currentIndex],
                                  onSwipe: _onSwipe,
                                ),
                              ),
                            ),
                            // Action buttons
                            Positioned(
                              bottom: 40,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FloatingActionButton(
                                    heroTag: 'dislike',
                                    onPressed: () => _onSwipe(false),
                                    backgroundColor: Colors.white,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    heroTag: 'like',
                                    onPressed: () => _onSwipe(true),
                                    backgroundColor: Colors.white,
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No more users to discover',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Check back later for more profiles!',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _fetchUsers,
                                child: const Text('Refresh Users'),
                              ),
                            ],
                          ),
                        ),
    );
  }
}