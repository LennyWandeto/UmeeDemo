import 'package:flutter/material.dart';
import '../../../data/dummy_data/dummy_users.dart';
import '../../../data/models/user_model.dart';
import 'widgets/swipe_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<User> users = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    users = DummyUsers.otherUsers;
  }

  void _onSwipe(bool isLike) {
    if (currentIndex < users.length - 1) {
      setState(() {
        currentIndex++;
      });
      
      if (isLike) {
        _showMatchDialog(users[currentIndex - 1]);
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
              Icons.favorite,
              color: Colors.red,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              'It\'s a Match!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You and ${user.name} liked each other',
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
                      // TODO: Navigate to chat
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
              setState(() {
                currentIndex = 0;
              });
            },
            child: const Text('Start Over'),
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
      body: currentIndex < users.length
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
                      FloatingActionButton.large(
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
                    onPressed: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            ),
    );
  }
}