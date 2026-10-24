import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'comment_sheet.dart';
import 'gradient_border_avatar.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool _showHeartAnim = false;
  late AnimationController _heartAnimController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 40),
    ]).animate(_heartAnimController);
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final appState = AppStateProvider.of(context);
    if (!widget.post.isLiked) {
      appState.togglePostLike(widget.post.id);
    }
    setState(() {
      _showHeartAnim = true;
    });
    _heartAnimController.forward(from: 0.0).then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showHeartAnim = false;
          });
        }
      });
    });
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentSheet(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                GradientBorderAvatar(
                  imageUrl: post.userAvatar,
                  radius: 18,
                  hasStory: true,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (post.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: AppTheme.primaryPink,
                            ),
                          ],
                        ],
                      ),
                      if (post.location.isNotEmpty)
                        Text(
                          post.location,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.bookmark_outline),
                            title: Text(
                                post.isSaved ? 'Unsave Post' : 'Save Post'),
                            onTap: () {
                              Navigator.pop(ctx);
                              appState.togglePostBookmark(post.id);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share),
                            title: const Text('Share to...'),
                            onTap: () => Navigator.pop(ctx),
                          ),
                          ListTile(
                            leading:
                                const Icon(Icons.report, color: Colors.red),
                            title: const Text('Report Post',
                                style: TextStyle(color: Colors.red)),
                            onTap: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Post Image with double-tap heart animation
          GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Image.network(
                    post.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                if (_showHeartAnim)
                  ScaleTransition(
                    scale: _heartScale,
                    child: Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
          ),

          // Action Buttons Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => appState.togglePostLike(post.id),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey<bool>(post.isLiked),
                      color: post.isLiked ? AppTheme.primaryPink : Colors.black,
                      size: 26,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _openComments,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post link copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.near_me_outlined, size: 24),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => appState.togglePostBookmark(post.id),
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isSaved ? AppTheme.primaryPurple : Colors.black,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          // Likes Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${post.likesCount} likes',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Caption & Hashtags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13.5),
                children: [
                  TextSpan(
                    text: '${post.username} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: post.caption),
                  if (post.hashtags.isNotEmpty) ...[
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: post.hashtags.join(' '),
                      style: const TextStyle(
                        color: AppTheme.accentBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // View Comments Button
          if (post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: _openComments,
                child: Text(
                  'View all ${post.commentsCount} comments',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),

          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.timeAgo.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
