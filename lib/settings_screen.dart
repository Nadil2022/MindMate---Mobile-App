import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _isDarkTheme = true;
  bool _biometricLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SettingsCard(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {},
          ),
          _SettingsCard(icon: Icons.translate, title: 'Language', onTap: () {}),
          _SettingsCard(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          _ToggleCard(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Theme',
            value: _isDarkTheme,
            onChanged: (val) {
              setState(() => _isDarkTheme = val);
              widget.onThemeChanged(val);
            },
          ),
          _ToggleCard(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          _ToggleCard(
            icon: Icons.fingerprint,
            title: 'Biometric Login',
            value: _biometricLogin,
            onChanged: (val) => setState(() => _biometricLogin = val),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Log Out', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      tileColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white38,
      ),
      onTap: onTap,
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
