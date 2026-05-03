// lib/desktop_workspace/admin_page.dart
import 'package:flutter/material.dart';
import 'inventory_view.dart';
import 'staff_view.dart';
import 'profile_view.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 1; // Default to Inventory view
  bool _isSidebarExpanded = false;
  int? _hoveredIndex;

  // --- COLOR PALETTE ---
  static const Color _primaryOrange = Color(0xFFEA580C);
  static const Color _darkSidebarBg = Color(0xFF0F172A);
  static const Color _mainBg = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBg,
      body: Row(
        children: [
          // --- EXPANDABLE SIDEBAR ---
          MouseRegion(
            onEnter: (_) => setState(() => _isSidebarExpanded = true),
            onExit: (_) => setState(() => _isSidebarExpanded = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: _isSidebarExpanded ? 240 : 88,
              color: _darkSidebarBg,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 40.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 30),
                        const Icon(
                          Icons.inventory_2_rounded,
                          color: _primaryOrange,
                          size: 28,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              opacity: _isSidebarExpanded ? 1.0 : 0.0,
                              child: Row(
                                children: const [
                                  SizedBox(width: 16),
                                  Text(
                                    'Inventory Plus',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSidebarItem(0, Icons.qr_code_scanner, 'Scan'),
                  _buildSidebarItem(
                    1,
                    Icons.inventory_2_outlined,
                    'Inventory',
                    activeIcon: Icons.inventory_2,
                  ),
                  _buildSidebarItem(
                    2,
                    Icons.settings_outlined,
                    'Settings',
                    activeIcon: Icons.settings,
                  ),
                  _buildSidebarItem(
                    3,
                    Icons.people_outline,
                    'Staff',
                    activeIcon: Icons.people,
                  ),
                  _buildSidebarItem(
                    4,
                    Icons.person_outline,
                    'Profile',
                    activeIcon: Icons.person,
                  ),
                ],
              ),
            ),
          ),

          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xFFE2E8F0),
          ),

          // --- MAIN CONTENT AREA ---
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    int index,
    IconData icon,
    String label, {
    IconData? activeIcon,
  }) {
    final isSelected = _selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    final currentColor = isSelected || isHovered
        ? _primaryOrange
        : const Color(0xFF94A3B8);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: isSelected
              ? _primaryOrange.withOpacity(0.05)
              : Colors.transparent,
          child: Row(
            children: [
              const SizedBox(width: 30),
              Icon(
                isSelected ? (activeIcon ?? icon) : icon,
                color: currentColor,
                size: 28,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _isSidebarExpanded ? 1.0 : 0.0,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          label,
                          style: TextStyle(
                            color: currentColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Route to the appropriate View based on the sidebar selection
  Widget _buildMainContent() {
    if (_selectedIndex == 1) return const InventoryView();
    if (_selectedIndex == 3) return const StaffView();
    if (_selectedIndex == 4) return const ProfileView(); // ADD THIS
    if (_selectedIndex == 0) return _buildScanPlaceholder();
    
    // Placeholder for Settings tab
    return Center(
      child: Text(
        'Selected Tab: $_selectedIndex',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  // Placeholder for the Scan Tab
  Widget _buildScanPlaceholder() {
    return Container(
      color: _darkSidebarBg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.center_focus_weak,
              size: 150,
              color: _primaryOrange,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.fullscreen),
              label: const Text('Simulate Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
