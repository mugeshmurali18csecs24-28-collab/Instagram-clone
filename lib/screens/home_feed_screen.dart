import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/connectly_logo.dart';
import '../widgets/gradient_border_avatar.dart';
import '../widgets/post_card.dart';
import '../widgets/story_viewer.dart';
import 'chat_list_screen.dart';
import 'notifications_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {});
    }
  }

  void _openAddStoryDialog() {
    final TextEditingController captionController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add to Your Story'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Icon(Icons.add_a_photo, color: Colors.white, size: 36),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: 'Add a story caption...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPink,
            ),
            onPressed: () {
              final appState = AppStateProvider.of(context);
              appState.addStory(
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
                captionController.text,
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Story posted! ✨'),
                  backgroundColor: AppTheme.primaryPink,
                ),
              );
            },
            child: const Text('Share', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final stories = appState.stories;
    final posts = appState.posts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const ConnectlyLogo(fontSize: 22),
        elevation: 0.5,
        actions: [
          // Notifications Icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              if (appState.unreadNotificationsCount > 0)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          // Messages Direct Icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatListScreen(),
                    ),
                  );
                },
              ),
              if (appState.unreadMessagesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${appState.unreadMessagesCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryPink,
        onRefresh: _refreshFeed,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Horizontal Stories Bar
              Container(
                height: 110,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    final isMe = story.userId == appState.currentUser.id;

                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          GradientBorderAvatar(
                            imageUrl: story.userAvatar,
                            radius: 30,
                            hasStory: true,
                            isStoryViewed: story.isViewed,
                            isAddStory: isMe,
                            onTap: () {
                              if (isMe && stories.length == 1) {
                                _openAddStoryDialog();
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoryViewerScreen(
                                      stories: stories,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 68,
                            child: Text(
                              isMe ? 'Your Story' : story.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: AppTheme.divider),

              // Posts List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: posts[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
