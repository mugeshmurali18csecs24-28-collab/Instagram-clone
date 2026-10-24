import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // Current logged in user profile
  late User _currentUser;
  
  // App collections
  List<Story> _stories = [];
  List<Post> _posts = [];
  List<Reel> _reels = [];
  List<NotificationModel> _notifications = [];
  List<ChatConversation> _conversations = [];
  List<User> _suggestedUsers = [];
  List<String> _exploreImages = [];

  User get currentUser => _currentUser;
  List<Story> get stories => _stories;
  List<Post> get posts => _posts;
  List<Reel> get reels => _reels;
  List<NotificationModel> get notifications => _notifications;
  List<ChatConversation> get conversations => _conversations;
  List<User> get suggestedUsers => _suggestedUsers;
  List<String> get exploreImages => _exploreImages;

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  int get unreadMessagesCount =>
      _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  AppState() {
    _initSampleData();
  }

  void _initSampleData() {
    _currentUser = User(
      id: 'usr_me',
      username: 'alex_rivera',
      name: 'Alex Rivera',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
      bio: '📸 Visual Storyteller | Digital Creator ✨\n📍 San Francisco, CA\n🌍 Exploring moments through light & shadow',
      website: 'connectly.app/alex_rivera',
      isVerified: true,
      followersCount: 14200,
      followingCount: 382,
      postsCount: 24,
      isFollowing: false,
    );

    _stories = [
      Story(
        id: 'story_0',
        userId: 'usr_me',
        username: 'Your Story',
        userAvatar: _currentUser.avatarUrl,
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
        timeAgo: 'Just now',
        isViewed: true,
        caption: 'Morning vibes in San Francisco ☀️',
      ),
      Story(
        id: 'story_1',
        userId: 'usr_1',
        username: 'sophia_m',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&auto=format&fit=crop&q=80',
        timeAgo: '2h ago',
        isViewed: false,
        caption: 'Coffee date with friends ☕️✨',
      ),
      Story(
        id: 'story_2',
        userId: 'usr_2',
        username: 'design_nexus',
        userAvatar:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80',
        imageUrl:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=80',
        timeAgo: '4h ago',
        isViewed: false,
        caption: '3D Gradient experiments for Connectly UI 🎨',
      ),
      Story(
        id: 'story_3',
        userId: 'usr_3',
        username: 'marcos_fit',
        userAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
        imageUrl:
            'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&auto=format&fit=crop&q=80',
        timeAgo: '6h ago',
        isViewed: false,
        caption: 'Leg day conquered 💪🔥',
      ),
      Story(
        id: 'story_4',
        userId: 'usr_4',
        username: 'elena_travels',
        userAvatar:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop&q=80',
        timeAgo: '8h ago',
        isViewed: false,
        caption: 'Sunset in Yosemite National Park 🌄',
      ),
      Story(
        id: 'story_5',
        userId: 'usr_5',
        username: 'chef_liam',
        userAvatar:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&auto=format&fit=crop&q=80',
        timeAgo: '12h ago',
        isViewed: true,
        caption: 'Fresh artisan pasta ready! 🍝',
      ),
    ];

    _posts = [
      Post(
        id: 'post_1',
        userId: 'usr_1',
        username: 'sophia_m',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
        isVerified: true,
        location: 'Kyoto, Japan',
        imageUrl:
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1000&auto=format&fit=crop&q=80',
        caption:
            'Wandering through the peaceful bamboo groves of Arashiyama 🎋 Nothing compares to the quiet beauty of Kyoto in autumn.',
        hashtags: ['#Kyoto', '#TravelJapan', '#Wanderlust', '#ConnectlyTravel'],
        likesCount: 1284,
        commentsCount: 94,
        isLiked: true,
        isSaved: false,
        timeAgo: '2 hours ago',
        comments: [
          Comment(
            id: 'c1',
            username: 'elena_travels',
            userAvatar:
                'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80',
            text: 'This looks so serene! On my bucket list for next spring 🌸',
            timeAgo: '1h ago',
            likesCount: 12,
            isLiked: true,
          ),
          Comment(
            id: 'c2',
            username: 'alex_rivera',
            userAvatar: _currentUser.avatarUrl,
            text: 'Stunning framing and golden hour colors! ✨',
            timeAgo: '30m ago',
            likesCount: 5,
            isLiked: false,
          ),
        ],
      ),
      Post(
        id: 'post_2',
        userId: 'usr_2',
        username: 'design_nexus',
        userAvatar:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80',
        isVerified: true,
        location: 'Design Studio, SF',
        imageUrl:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1000&auto=format&fit=crop&q=80',
        caption:
            'Exploring sleek glassmorphism and purple-pink gradient accents for the brand new Connectly mobile UI standard. What do you think of this layout?',
        hashtags: [
          '#UIDesign',
          '#FlutterUI',
          '#ProductDesign',
          '#ConnectlyDesign'
        ],
        likesCount: 3890,
        commentsCount: 210,
        isLiked: false,
        isSaved: true,
        timeAgo: '5 hours ago',
        comments: [
          Comment(
            id: 'c3',
            username: 'marcos_fit',
            userAvatar:
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
            text: 'Clean typography and smooth shadows! Love it 🔥',
            timeAgo: '4h ago',
            likesCount: 8,
          ),
        ],
      ),
      Post(
        id: 'post_3',
        userId: 'usr_4',
        username: 'elena_travels',
        userAvatar:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80',
        isVerified: false,
        location: 'Amalfi Coast, Italy',
        imageUrl:
            'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=1000&auto=format&fit=crop&q=80',
        caption:
            'Cliffside lemon groves and azure Mediterranean waters 🍋🌊 The coastal road was an unforgettable drive.',
        hashtags: ['#Amalfi', '#ItalyStyle', '#SummerVibes', '#CoastalViews'],
        likesCount: 2410,
        commentsCount: 135,
        isLiked: false,
        isSaved: false,
        timeAgo: '1 day ago',
        comments: [],
      ),
      Post(
        id: 'post_4',
        userId: 'usr_5',
        username: 'chef_liam',
        userAvatar:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=80',
        isVerified: true,
        location: 'Le Bistro, Paris',
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1000&auto=format&fit=crop&q=80',
        caption:
            'Truffle handmade ravioli tossed in brown butter sage. Simple ingredients elevated with craft. 🍝🍷',
        hashtags: ['#Foodie', '#Gourmet', '#ChefLife', '#ParisEats'],
        likesCount: 1872,
        commentsCount: 88,
        isLiked: true,
        isSaved: true,
        timeAgo: '2 days ago',
        comments: [],
      ),
    ];

    _reels = [
      Reel(
        id: 'reel_1',
        userId: 'usr_1',
        username: 'sophia_m',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
        videoThumbnail:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
        caption: '5 hidden spots in Tokyo you must visit in 2025! 🇯🇵✨',
        musicTitle: 'Sophia • Original Audio - Tokyo Sunset Dreams',
        likesCount: 45200,
        commentsCount: 1340,
        sharesCount: 8900,
        isLiked: true,
        isFollowing: true,
      ),
      Reel(
        id: 'reel_2',
        userId: 'usr_3',
        username: 'marcos_fit',
        userAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
        videoThumbnail:
            'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&auto=format&fit=crop&q=80',
        caption: '15 Min Morning Mobility Routine for Peak Performance 💪⚡️',
        musicTitle: 'Fitness Beats • High Energy Synthwave',
        likesCount: 89400,
        commentsCount: 2110,
        sharesCount: 14200,
        isLiked: false,
        isFollowing: false,
      ),
      Reel(
        id: 'reel_3',
        userId: 'usr_2',
        username: 'design_nexus',
        userAvatar:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80',
        videoThumbnail:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=80',
        caption: 'Building smooth animations in Flutter with Connectly SDK 🚀',
        musicTitle: 'Lo-Fi Chill Hop • Coding Grooves',
        likesCount: 31200,
        commentsCount: 840,
        sharesCount: 5600,
        isLiked: false,
        isFollowing: false,
      ),
    ];

    _notifications = [
      NotificationModel(
        id: 'notif_1',
        type: NotificationType.like,
        username: 'sophia_m',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
        postImage:
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=200&auto=format&fit=crop&q=80',
        timeAgo: '15m ago',
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_2',
        type: NotificationType.comment,
        username: 'design_nexus',
        userAvatar:
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80',
        postImage:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=200&auto=format&fit=crop&q=80',
        timeAgo: '1h ago',
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_3',
        type: NotificationType.follow,
        username: 'marcos_fit',
        userAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=80',
        timeAgo: '3h ago',
        isRead: true,
        isFollowingBack: false,
      ),
      NotificationModel(
        id: 'notif_4',
        type: NotificationType.mention,
        username: 'elena_travels',
        userAvatar:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80',
        postImage:
            'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=200&auto=format&fit=crop&q=80',
        timeAgo: '1d ago',
        isRead: true,
      ),
    ];

    _suggestedUsers = [
      User(
        id: 'usr_10',
        username: 'lisa_art',
        name: 'Lisa Chen',
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
        bio: 'Abstract Painter & Illustrator',
        followersCount: 8900,
      ),
      User(
        id: 'usr_11',
        username: 'tech_insider',
        name: 'Tech Insider Daily',
        avatarUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500&auto=format&fit=crop&q=80',
        bio: 'Future Tech, AI & Gadgets',
        isVerified: true,
        followersCount: 52000,
      ),
      User(
        id: 'usr_12',
        username: 'chloe_reads',
        name: 'Chloe Bennett',
        avatarUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500&auto=format&fit=crop&q=80',
        bio: 'Book recommendations & cozy vibes',
        followersCount: 14200,
      ),
    ];

    _conversations = [
      ChatConversation(
        id: 'chat_1',
        user: User(
          id: 'usr_1',
          username: 'sophia_m',
          name: 'Sophia Miller',
          avatarUrl:
              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=80',
          isVerified: true,
        ),
        lastMessage: 'Hey Alex! Loved your latest photo set from SF! 📸',
        lastMessageTime: '10:42 AM',
        unreadCount: 2,
        isOnline: true,
        messages: [
          ChatMessage(
            id: 'm1',
            senderId: 'usr_1',
            text: 'Hey Alex! Hope you are doing well!',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm2',
            senderId: 'usr_1',
            text: 'Loved your latest photo set from SF! 📸 What lens did you use?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
            isMe: false,
          ),
        ],
      ),
      ChatConversation(
        id: 'chat_2',
        user: User(
          id: 'usr_2',
          username: 'design_nexus',
          name: 'Nexus Design Studio',
          avatarUrl:
              'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500&auto=format&fit=crop&q=80',
          isVerified: true,
        ),
        lastMessage: 'The new Connectly UI kit is ready for review.',
        lastMessageTime: 'Yesterday',
        unreadCount: 0,
        isOnline: true,
        messages: [
          ChatMessage(
            id: 'm3',
            senderId: 'usr_me',
            text: 'Can you send over the Figma links?',
            timestamp: DateTime.now().subtract(const Duration(hours: 24)),
            isMe: true,
          ),
          ChatMessage(
            id: 'm4',
            senderId: 'usr_2',
            text: 'The new Connectly UI kit is ready for review.',
            timestamp: DateTime.now().subtract(const Duration(hours: 23)),
            isMe: false,
          ),
        ],
      ),
      ChatConversation(
        id: 'chat_3',
        user: User(
          id: 'usr_4',
          username: 'elena_travels',
          name: 'Elena Rostova',
          avatarUrl:
              'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500&auto=format&fit=crop&q=80',
        ),
        lastMessage: 'See you in Kyoto next month! 🇯🇵',
        lastMessageTime: 'Tue',
        unreadCount: 0,
        isOnline: false,
        messages: [
          ChatMessage(
            id: 'm5',
            senderId: 'usr_4',
            text: 'See you in Kyoto next month! 🇯🇵',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            isMe: false,
          ),
        ],
      ),
    ];

    _exploreImages = [
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800&auto=format&fit=crop&q=80',
    ];
  }

  // State Action Methods
  void updateProfile({
    required String name,
    required String username,
    required String bio,
    required String website,
  }) {
    _currentUser.name = name;
    _currentUser.username = username;
    _currentUser.bio = bio;
    _currentUser.website = website;
    notifyListeners();
  }

  void togglePostLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      post.isLiked = !post.isLiked;
      if (post.isLiked) {
        post.likesCount++;
      } else {
        post.likesCount--;
      }
      notifyListeners();
    }
  }

  void togglePostBookmark(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isSaved = !_posts[index].isSaved;
      notifyListeners();
    }
  }

  void addComment(String postId, String text) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1 && text.trim().isNotEmpty) {
      final post = _posts[index];
      post.comments.insert(
        0,
        Comment(
          id: 'c_${DateTime.now().millisecondsSinceEpoch}',
          username: _currentUser.username,
          userAvatar: _currentUser.avatarUrl,
          text: text.trim(),
          timeAgo: 'Just now',
        ),
      );
      post.commentsCount++;
      notifyListeners();
    }
  }

  void createPost({
    required String imageUrl,
    required String caption,
    required String location,
    required List<String> hashtags,
  }) {
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      username: _currentUser.username,
      userAvatar: _currentUser.avatarUrl,
      isVerified: _currentUser.isVerified,
      location: location.isNotEmpty ? location : 'San Francisco, CA',
      imageUrl: imageUrl.isNotEmpty
          ? imageUrl
          : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1000&auto=format&fit=crop&q=80',
      caption: caption,
      hashtags: hashtags,
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
      isSaved: false,
      timeAgo: 'Just now',
      comments: [],
    );

    _posts.insert(0, newPost);
    _currentUser.postsCount++;
    notifyListeners();
  }

  void addStory(String imageUrl, String caption) {
    final newStory = Story(
      id: 'story_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser.id,
      username: 'Your Story',
      userAvatar: _currentUser.avatarUrl,
      imageUrl: imageUrl.isNotEmpty
          ? imageUrl
          : 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
      timeAgo: 'Just now',
      isViewed: true,
      caption: caption,
    );

    // Replace user story if exists or insert
    _stories.removeWhere((s) => s.userId == _currentUser.id);
    _stories.insert(0, newStory);
    notifyListeners();
  }

  void toggleReelLike(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index != -1) {
      final reel = _reels[index];
      reel.isLiked = !reel.isLiked;
      if (reel.isLiked) {
        reel.likesCount++;
      } else {
        reel.likesCount--;
      }
      notifyListeners();
    }
  }

  void toggleReelFollow(String reelId) {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index != -1) {
      _reels[index].isFollowing = !_reels[index].isFollowing;
      notifyListeners();
    }
  }

  void sendMessage(String conversationId, String text) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && text.trim().isNotEmpty) {
      final conv = _conversations[index];
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: _currentUser.id,
        text: text.trim(),
        timestamp: DateTime.now(),
        isMe: true,
      );
      conv.messages.add(newMsg);
      conv.lastMessage = text.trim();
      conv.lastMessageTime = 'Just now';
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void toggleFollowUser(String userId) {
    final index = _suggestedUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _suggestedUsers[index].isFollowing = !_suggestedUsers[index].isFollowing;
      notifyListeners();
    }
  }
}

// InheritedNotifier Provider for easy access across the Widget Tree
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
