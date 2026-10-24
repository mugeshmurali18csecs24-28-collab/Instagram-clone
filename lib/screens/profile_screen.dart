import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/gradient_border_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _highlights = [
    {
      'title': 'SF Vibes',
      'img':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=300&auto=format&fit=crop&q=80'
    },
    {
      'title': 'Kyoto ⛩️',
      'img':
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=300&auto=format&fit=crop&q=80'
    },
    {
      'title': 'Design 🎨',
      'img':
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=300&auto=format&fit=crop&q=80'
    },
    {
      'title': 'Travel ✈️',
      'img':
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=300&auto=format&fit=crop&q=80'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileSheet(),
    );
  }

  void _showFollowersModal(String title, int count) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final appState = AppStateProvider.of(context);
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$title ($count)',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: appState.suggestedUsers.length,
                  itemBuilder: (context, index) {
                    final u = appState.suggestedUsers[index];
                    return ListTile(
                      leading: GradientBorderAvatar(
                        imageUrl: u.avatarUrl,
                        radius: 20,
                      ),
                      title: Text(u.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('@${u.username}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: u.isFollowing
                              ? Colors.grey.shade200
                              : AppTheme.primaryPink,
                          elevation: 0,
                        ),
                        onPressed: () {
                          appState.toggleFollowUser(u.id);
                          (ctx as Element).markNeedsBuild();
                        },
                        child: Text(
                          u.isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            color: u.isFollowing ? Colors.black87 : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final user = appState.currentUser;
    final userPosts = appState.posts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              user.username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (user.isVerified) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.verified,
                color: AppTheme.primaryPink,
                size: 18,
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 26),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Use Create Post tab to upload!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings & Privacy'),
                      onTap: () => Navigator.pop(ctx),
                    ),
                    ListTile(
                      leading: const Icon(Icons.archive_outlined),
                      title: const Text('Your Activity & Archive'),
                      onTap: () => Navigator.pop(ctx),
                    ),
                    ListTile(
                      leading: const Icon(Icons.qr_code_scanner),
                      title: const Text('QR Code'),
                      onTap: () => Navigator.pop(ctx),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.logout_rounded, color: Colors.red),
                      title: const Text('Log Out',
                          style: TextStyle(color: Colors.red)),
                      onTap: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Profile Info & Stats Row
                    Row(
                      children: [
                        GradientBorderAvatar(
                          imageUrl: user.avatarUrl,
                          radius: 40,
                          hasStory: true,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn('Posts', user.postsCount, () {}),
                              _buildStatColumn('Followers', user.followersCount,
                                  () {
                                _showFollowersModal(
                                    'Followers', user.followersCount);
                              }),
                              _buildStatColumn('Following', user.followingCount,
                                  () {
                                _showFollowersModal(
                                    'Following', user.followingCount);
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Name, Bio, Website
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.bio,
                      style: const TextStyle(fontSize: 13.5, height: 1.3),
                    ),
                    if (user.website.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.website,
                        style: const TextStyle(
                          color: AppTheme.accentBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _openEditProfile,
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profile link copied!')),
                              );
                            },
                            child: const Text(
                              'Share Profile',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Story Highlights Bar
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _highlights.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: const Icon(Icons.add,
                                        size: 24, color: Colors.black),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('New',
                                      style: TextStyle(fontSize: 11)),
                                ],
                              ),
                            );
                          }
                          final hl = _highlights[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: NetworkImage(hl['img']!),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hl['title']!,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryPink,
                  labelColor: AppTheme.primaryPink,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on_rounded)),
                    Tab(icon: Icon(Icons.video_collection_outlined)),
                    Tab(icon: Icon(Icons.bookmark_border_rounded)),
                    Tab(icon: Icon(Icons.assignment_ind_outlined)),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Posts Grid
            GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(post.imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),

            // Tab 2: Reels Grid
            GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: appState.reels.length,
              itemBuilder: (context, index) {
                final reel = appState.reels[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(reel.videoThumbnail, fit: BoxFit.cover),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${reel.likesCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Tab 3: Saved Posts
            GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: userPosts.where((p) => p.isSaved).length,
              itemBuilder: (context, index) {
                final savedPost =
                    userPosts.where((p) => p.isSaved).toList()[index];
                return Image.network(savedPost.imageUrl, fit: BoxFit.cover);
              },
            ),

            // Tab 4: Tagged Posts
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_ind_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  const Text('No tagged photos yet',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            _formatNumber(value),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}k';
    }
    return num.toString();
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
