import 'package:flutter/material.dart';
import '../theme.dart';
import '../mock_api.dart';
import '../translations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: Translations.currentLang,
      builder: (context, lang, child) {
        final mockUser = MockApi.userData;

        final String name = mockUser['name'];
        final String email = mockUser['email'];
        final String? photoUrl = mockUser['profileUrl'];

        return Scaffold(
          backgroundColor: context.bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(Translations.get('settings_title'), style: TextStyle(fontWeight: FontWeight.bold, color: context.textMain)),
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
                      child: photoUrl == null ? Icon(Icons.person, color: context.textMain, size: 40) : null,
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: TextStyle(color: context.textMain, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(email, style: TextStyle(color: context.textTertiary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              _buildSettingsSection(context, Translations.get('section_account')),
              _buildSettingsTile(context, Icons.person_outline_rounded, Translations.get('personal_info')),
              _buildSettingsTile(context, Icons.notifications_none_rounded, Translations.get('notifications')),
              _buildSettingsTile(context, Icons.security_rounded, Translations.get('security_privacy')),
              
              const SizedBox(height: 32),
              _buildSettingsSection(context, Translations.get('section_system')),
              GestureDetector(
                onTap: () {
                  if (Translations.currentLang.value == 'th') {
                    Translations.changeLanguage('en');
                  } else {
                    Translations.changeLanguage('th');
                  }
                },
                child: _buildSettingsTile(
                  context,
                  Icons.language_rounded, 
                  Translations.get('language'), 
                  trailing: Translations.currentLang.value == 'th' ? 'ไทย' : 'English',
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppTheme.toggleTheme();
                },
                child: _buildSettingsTile(
                  context,
                  Icons.dark_mode_outlined, 
                  Translations.get('dark_mode'), 
                  trailing: context.isDark ? Translations.get('always_on') : 'Off'
                ),
              ),
              
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: AppTheme.danger),
                      const SizedBox(width: 12),
                      Text(Translations.get('sign_out'), style: const TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title.toUpperCase(), style: TextStyle(color: context.textFaded, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, {String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.textSec, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(color: context.textMain, fontWeight: FontWeight.w600))),
          if (trailing != null)
            Text(trailing, style: TextStyle(color: context.textFaded, fontSize: 14)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: context.borderFaded),
        ],
      ),
    );
  }
}

