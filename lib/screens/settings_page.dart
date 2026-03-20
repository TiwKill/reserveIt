import 'package:flutter/material.dart';
import '../theme.dart';
import '../mock_api.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockUser = MockApi.userData;

    final String name = mockUser['name'];
    final String email = mockUser['email'];
    final String? photoUrl = mockUser['profileUrl'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
                ),
                const SizedBox(height: 16),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(email, style: const TextStyle(color: Colors.white38, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          
          _buildSettingsSection('Account'),
          _buildSettingsTile(Icons.person_outline_rounded, 'Personal Information'),
          _buildSettingsTile(Icons.notifications_none_rounded, 'Notifications'),
          _buildSettingsTile(Icons.security_rounded, 'Security & Privacy'),
          
          const SizedBox(height: 32),
          _buildSettingsSection('System'),
          _buildSettingsTile(Icons.language_rounded, 'Language', trailing: 'English (US)'),
          _buildSettingsTile(Icons.dark_mode_outlined, 'Dark Mode', trailing: 'Always On'),
          
          const SizedBox(height: 48),
          // Logout
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.danger.withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: AppTheme.danger),
                  SizedBox(width: 12),
                  Text('Sign Out', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.white24, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Colors.white12),
        ],
      ),
    );
  }
}

