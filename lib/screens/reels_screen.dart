import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/comment_sheet.dart';
import '../widgets/gradient_border_avatar.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _discAnimController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _discAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _discAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final reels = appState.reels;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              // Simulated Reel Video Image Background
              Image.network(
                reel.videoThumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(Icons.videocam, color: Colors.white, size: 64),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black38,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Top Title Overlay
              const Positioned(
                top: 50,
                left: 20,
                child: Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Right Actions Sidebar
              Positioned(
                right: 16,
                bottom: 80,
                child: Column(
                  children: [
                    // Like button
                    _buildActionButton(
                      icon: reel.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      iconColor:
                          reel.isLiked ? AppTheme.primaryPink : Colors.white,
                      label: '${reel.likesCount}',
                      onTap: () => appState.toggleReelLike(reel.id),
                    ),
                    const SizedBox(height: 20),

                    // Comment button
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: '${reel.commentsCount}',
                      onTap: () {
                        // Open comment sheet
                        final post = appState.posts[0];
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => CommentSheet(post: post),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Share button
                    _buildActionButton(
                      icon: Icons.near_me_outlined,
                      label: '${reel.sharesCount}',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reel link copied!')),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Rotating Music Vinyl Disc
                    AnimatedBuilder(
                      animation: _discAnimController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _discAnimController.value * 2 * math.pi,
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              backgroundColor: AppTheme.primaryPink,
                              child: Icon(Icons.music_note,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Caption & Creator Info Overlay
              Positioned(
                left: 16,
                right: 80,
                bottom: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info row
                    Row(
                      children: [
                        GradientBorderAvatar(
                          imageUrl: reel.userAvatar,
                          radius: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          reel.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => appState.toggleReelFollow(reel.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: reel.isFollowing
                                  ? Colors.white24
                                  : AppTheme.primaryPink,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              reel.isFollowing ? 'Following' : 'Follow',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Reel Caption
                    Text(
                      reel.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Audio Track Marquee
                    Row(
                      children: [
                        const Icon(Icons.music_note,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            reel.musicTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color iconColor = Colors.white,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
