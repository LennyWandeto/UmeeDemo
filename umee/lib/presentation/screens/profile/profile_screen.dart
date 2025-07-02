// lib/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../../data/dummy_data/dummy_chats.dart'; // Import dummy data

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access dummy data directly from DummyData class
    final String userName = DummyData.currentUserName;
    final String userProfilePic = DummyData.currentUserProfilePic;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userProfilePic),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View and manage your profile settings.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                      title: Text('Edit Profile', style: Theme.of(context).textTheme.titleMedium),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle edit profile
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Profile tapped! (Demo)')),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.photo, color: Theme.of(context).colorScheme.primary),
                      title: Text('Change Profile Picture', style: Theme.of(context).textTheme.titleMedium),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle change profile picture
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change Profile Picture tapped! (Demo)')),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                      title: Text('Account Settings', style: Theme.of(context).textTheme.titleMedium),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle account settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account Settings tapped! (Demo)')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Handle sign out (for demo, just show a message)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out! (Demo)')),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                minimumSize: const Size(double.infinity, 50), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}