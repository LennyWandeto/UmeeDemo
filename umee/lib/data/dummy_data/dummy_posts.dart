import '../models/post_model.dart';

class DummyPosts {
  static final List<Post> posts = [
    Post(
      id: '1',
      userId: '1',
      content: 'Just captured the most beautiful sunset from my rooftop! Sometimes the best moments happen when you least expect them. 🌅✨',
      images: ['https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 24,
      comments: 5,
      isLiked: true,
    ),
    Post(
      id: '2',
      userId: '2',
      content: 'Finally mastered the perfect ramen recipe after 50+ attempts! The secret is in the broth timing. Who wants the recipe? 🍜👨‍🍳',
      images: ['https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      likes: 67,
      comments: 12,
      isLiked: false,
    ),
    Post(
      id: '3',
      userId: '3',
      content: 'Morning yoga session in the park. There\'s something magical about connecting with nature while finding your inner peace. Namaste! 🧘‍♀️🌳',
      images: ['https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      likes: 45,
      comments: 8,
      isLiked: true,
    ),
    Post(
      id: '4',
      userId: '4',
      content: 'Late night studio session vibes. Working on something special that I can\'t wait to share with you all. Music is life! 🎵🔥',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 89,
      comments: 15,
      isLiked: false,
    ),
    Post(
      id: '5',
      userId: '5',
      content: 'Beach day with my favorite companion! 🐕 Nothing beats a sunset walk with this good boy. Miami sunsets hit different.',
      images: ['https://images.unsplash.com/photo-1507146426996-ef05306b995a?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      likes: 156,
      comments: 23,
      isLiked: true,
    ),
    Post(
      id: '6',
      userId: '6',
      content: 'Crushed today\'s mountain hike! 15 miles and 3000ft elevation gain. The view from the top was absolutely worth every step. 🏔️💪',
      images: ['https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      likes: 78,
      comments: 9,
      isLiked: false,
    ),
    Post(
      id: '7',
      userId: '7',
      content: 'New plant baby joined the family today! 🌱 My apartment is slowly turning into a jungle and I\'m here for it. Any care tips for a fiddle leaf fig?',
      images: ['https://images.unsplash.com/photo-1463320726281-696a485928c7?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 34,
      comments: 7,
      isLiked: true,
    ),
    Post(
      id: '8',
      userId: '8',
      content: 'Excited to announce that our startup just closed Series A! 🚀 Couldn\'t have done it without this amazing team. Next stop: changing the world!',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      likes: 234,
      comments: 45,
      isLiked: false,
    ),
    Post(
      id: '9',
      userId: '9',
      content: 'Fashion week inspiration: mixing vintage with modern pieces. Sometimes the best outfits come from unexpected combinations! ✨👗',
      images: ['https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=400&h=300&fit=crop'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likes: 91,
      comments: 13,
      isLiked: true,
    ),
  ];

  static List<Post> getPostsWithUsers() {
    return posts;
  }
}