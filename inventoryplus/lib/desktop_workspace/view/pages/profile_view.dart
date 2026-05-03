// lib/desktop_workspace/profile_view.dart
import 'package:flutter/material.dart';
import '../../data/AuthService.dart'; // Adjust path if needed

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const Color _primaryOrange = Color(0xFFEA580C);
  static const Color _cardBg = Colors.white;
  static const Color _darkText = Color(0xFF1E293B);
  static const Color _greyText = Color(0xFF64748B);
  static const Color _redAlert = Color(0xFFEF4444);

  void _handleLogout(BuildContext context) async {
    // 1. Destroy backend session
    await AuthService().logout();

    // 2. Burn the navigation bridge (prevent back button)
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 32),

          Material(
            color: _cardBg,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: _primaryOrange,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active User',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _darkText,
                            ),
                          ),
                          Text(
                            'System Account',
                            style: TextStyle(fontSize: 16, color: _greyText),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 24),

                  const Text(
                    'Account Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _darkText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // The Logout Button
                  ElevatedButton.icon(
                    onPressed: () => _handleLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out Securely'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _redAlert.withOpacity(0.1),
                      foregroundColor: _redAlert,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
