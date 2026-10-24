import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'gradient_border_avatar.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    final user = AppStateProvider.of(context).currentUser;
    _nameController = TextEditingController(text: user.name);
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio);
    _websiteController = TextEditingController(text: user.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final appState = AppStateProvider.of(context);
    appState.updateProfile(
      name: _nameController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      website: _websiteController.text,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppTheme.primaryPink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppStateProvider.of(context).currentUser;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _saveProfile,
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: AppTheme.primaryPink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile photo change button
            GradientBorderAvatar(
              imageUrl: user.avatarUrl,
              radius: 40,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery photo picker opened')),
                );
              },
              child: const Text(
                'Change Profile Photo',
                style: TextStyle(
                  color: AppTheme.primaryPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form Fields
            _buildTextField(label: 'Name', controller: _nameController),
            const SizedBox(height: 12),
            _buildTextField(label: 'Username', controller: _usernameController),
            const SizedBox(height: 12),
            _buildTextField(
                label: 'Bio', controller: _bioController, maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField(label: 'Website', controller: _websiteController),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryPink, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
