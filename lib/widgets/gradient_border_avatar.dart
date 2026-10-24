import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientBorderAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool hasStory;
  final bool isStoryViewed;
  final bool isAddStory;
  final VoidCallback? onTap;

  const GradientBorderAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 32,
    this.hasStory = false,
    this.isStoryViewed = false,
    this.isAddStory = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double borderPadding = hasStory ? 3.0 : 0.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(borderPadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasStory
                  ? (isStoryViewed
                      ? const LinearGradient(
                          colors: [Color(0xFFCCCCCC), Color(0xFF999999)],
                        )
                      : AppTheme.storyGradient)
                  : null,
            ),
            child: Container(
              padding: EdgeInsets.all(hasStory ? 2.5 : 0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: AppTheme.divider,
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: radius,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isAddStory)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
