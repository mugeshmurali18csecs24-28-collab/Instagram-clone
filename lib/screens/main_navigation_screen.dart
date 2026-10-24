import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_border_avatar.dart';
import 'create_post_screen.dart';
import 'explore_screen.dart';
import 'home_feed_screen.dart';
import 'profile_screen.dart';
import 'reels_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    final List<Widget> screens = [
      const HomeFeedScreen(),
      const ExploreScreen(),
      CreatePostScreen(
        onPostPublished: () {
          setState(() {
            _currentIndex = 0; // Return to home feed after publishing
          });
        },
      ),
      const ReelsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryPink,
          unselectedItemColor: Colors.black87,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined, size: 28),
              activeIcon: ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.buttonGradient.createShader(bounds),
                child: const Icon(Icons.home_filled,
                    size: 28, color: Colors.white),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_rounded, size: 28),
              activeIcon: ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.buttonGradient.createShader(bounds),
                child:
                    const Icon(Icons.search_rounded, size: 28, color: Colors.white),
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: AppTheme.buttonGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 20),
              ),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.video_collection_outlined, size: 26),
              activeIcon: ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.buttonGradient.createShader(bounds),
                child: const Icon(Icons.video_collection_rounded,
                    size: 26, color: Colors.white),
              ),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: GradientBorderAvatar(
                imageUrl: appState.currentUser.avatarUrl,
                radius: 13,
                hasStory: false,
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  gradient: AppTheme.storyGradient,
                  shape: BoxShape.circle,
                ),
                child: GradientBorderAvatar(
                  imageUrl: appState.currentUser.avatarUrl,
                  radius: 12,
                  hasStory: false,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
