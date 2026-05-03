// lib/desktop_workspace/staff_view.dart
import 'package:flutter/material.dart';
import '../../controllers/staff_controller.dart';

class StaffView extends StatefulWidget {
  const StaffView({super.key});

  @override
  State<StaffView> createState() => _StaffViewState();
}

class _StaffViewState extends State<StaffView> {
  final _staffController = StaffController();

  // Color Palette
  static const Color _primaryOrange = Color(0xFFEA580C);
  static const Color _mainBg = Color(0xFFF1F5F9);
  static const Color _cardBg = Colors.white;
  static const Color _darkText = Color(0xFF1E293B);
  static const Color _greyText = Color(0xFF64748B);
  static const Color _redAlert = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _staffController.fetchStaff(); // Load data when this view opens
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Staff Management',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _darkText,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showStaffDialog(null),
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text(
                  'Add Staff',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListenableBuilder(
              listenable: _staffController,
              builder: (context, child) {
                if (_staffController.isLoading &&
                    _staffController.staffList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primaryOrange),
                  );
                }

                if (_staffController.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      _staffController.errorMessage,
                      style: const TextStyle(color: _redAlert),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 160,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: _staffController.staffList.length,
                  itemBuilder: (context, index) {
                    return _buildStaffCard(_staffController.staffList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    return Material(
      color: _cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    staff['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: _darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _mainBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (staff['role'] ?? 'staff').toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _greyText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Username: ${staff['username']}',
              style: const TextStyle(color: _greyText, fontSize: 14),
            ),
            const Text(
              'Password: ••••••••',
              style: TextStyle(color: _greyText, fontSize: 14),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showStaffDialog(staff),
                icon: const Icon(Icons.edit, size: 16, color: _primaryOrange),
                label: const Text(
                  'Edit Account',
                  style: TextStyle(color: _primaryOrange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStaffDialog(Map<String, dynamic>? existingStaff) {
    final isEditing = existingStaff != null;
    final nameCtrl = TextEditingController(
      text: isEditing ? existingStaff['name'] : '',
    );
    final usernameCtrl = TextEditingController(
      text: isEditing ? existingStaff['username'] : '',
    );
    final passwordCtrl = TextEditingController(
      text: isEditing ? existingStaff['password'] : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Staff Account' : 'Create Staff Account',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing
                      ? 'Update the details for this staff member below.'
                      : 'Add a new staff member to the system.',
                  style: const TextStyle(color: _greyText, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildModalTextField(
                  controller: nameCtrl,
                  label: 'Full Name',
                  hint: 'e.g. Junior Staff',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                _buildModalTextField(
                  controller: usernameCtrl,
                  label: 'Username',
                  hint: 'e.g. jstaff01',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildModalTextField(
                  controller: passwordCtrl,
                  label: 'Password',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: _greyText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        final data = {
                          'id': isEditing ? existingStaff['id'] : null,
                          'name': nameCtrl.text.trim(),
                          'username': usernameCtrl.text.trim(),
                          'password': passwordCtrl.text.trim(),
                        };

                        final success = await _staffController.saveStaff(data);
                        if (success && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing ? 'Staff Updated!' : 'Staff Created!',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        isEditing ? 'Save Changes' : 'Create Account',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: _darkText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _greyText),
        hintText: hint,
        hintStyle: TextStyle(color: _greyText.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: _primaryOrange, size: 20),
        filled: true,
        fillColor: _mainBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
