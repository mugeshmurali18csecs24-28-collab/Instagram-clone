class User {
  final String id;
  String username;
  String name;
  String avatarUrl;
  String bio;
  String website;
  bool isVerified;
  int followersCount;
  int followingCount;
  int postsCount;
  bool isFollowing;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.avatarUrl,
    this.bio = '',
    this.website = '',
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowing = false,
  });
}

class Comment {
  final String id;
  final String username;
  final String userAvatar;
  final String text;
  final String timeAgo;
  int likesCount;
  bool isLiked;

  Comment({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.text,
    required this.timeAgo,
    this.likesCount = 0,
    this.isLiked = false,
  });
}

class Post {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final bool isVerified;
  final String location;
  final String imageUrl;
  final String caption;
  final List<String> hashtags;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isSaved;
  final String timeAgo;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    this.isVerified = false,
    this.location = '',
    required this.imageUrl,
    required this.caption,
    required this.hashtags,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.timeAgo,
    required this.comments,
  });
}

class Story {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String imageUrl;
  final String timeAgo;
  bool isViewed;
  final String caption;

  Story({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.imageUrl,
    required this.timeAgo,
    this.isViewed = false,
    this.caption = '',
  });
}

class Reel {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String videoThumbnail;
  final String caption;
  final String musicTitle;
  int likesCount;
  int commentsCount;
  int sharesCount;
  bool isLiked;
  bool isSaved;
  bool isFollowing;

  Reel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.videoThumbnail,
    required this.caption,
    required this.musicTitle,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.isFollowing = false,
  });
}

enum NotificationType { like, comment, follow, mention }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String username;
  final String userAvatar;
  final String? postImage;
  final String timeAgo;
  bool isRead;
  bool isFollowingBack;

  NotificationModel({
    required this.id,
    required this.type,
    required this.username,
    required this.userAvatar,
    this.postImage,
    required this.timeAgo,
    this.isRead = false,
    this.isFollowingBack = false,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatConversation {
  final String id;
  final User user;
  String lastMessage;
  String lastMessageTime;
  int unreadCount;
  bool isOnline;
  final List<ChatMessage> messages;

  ChatConversation({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.messages,
  });
}
