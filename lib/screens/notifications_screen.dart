import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_border_avatar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final notifications = appState.notifications;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => appState.markAllNotificationsRead(),
            child: const Text(
              'Mark as Read',
              style: TextStyle(
                color: AppTheme.primaryPink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return GestureDetector(
                  onTap: () {
                    appState.markAllNotificationsRead();
                  },
                  child: Container(
                    color: notif.isRead
                        ? Colors.transparent
                        : AppTheme.primaryPink.withOpacity(0.04),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GradientBorderAvatar(
                          imageUrl: notif.userAvatar,
                          radius: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 13.5),
                              children: [
                                TextSpan(
                                  text: notif.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: _getNotificationText(notif.type)),
                                TextSpan(
                                  text: '  ${notif.timeAgo}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Action area (Follow button or Post Thumbnail)
                        if (notif.type == NotificationType.follow) ...[
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: notif.isFollowingBack
                                    ? Colors.grey.shade200
                                    : AppTheme.primaryPink,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                notif.isFollowingBack = !notif.isFollowingBack;
                                (context as Element).markNeedsBuild();
                              },
                              child: Text(
                                notif.isFollowingBack ? 'Following' : 'Follow Back',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: notif.isFollowingBack
                                      ? Colors.black87
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ] else if (notif.postImage != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              notif.postImage!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getNotificationText(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return ' liked your post.';
      case NotificationType.comment:
        return ' commented on your post.';
      case NotificationType.follow:
        return ' started following you.';
      case NotificationType.mention:
        return ' mentioned you in a comment.';
    }
  }
}
