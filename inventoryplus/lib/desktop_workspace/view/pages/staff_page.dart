// lib/desktop_workspace/staff_page.dart
import 'package:flutter/material.dart';
import 'inventory_view.dart';
import 'profile_view.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  int _selectedIndex = 0; // Default to Inventory (Index 0 for Staff)
  bool _isSidebarExpanded = false;
  int? _hoveredIndex;

  static const Color _primaryOrange = Color(0xFFEA580C);
  static const Color _darkSidebarBg = Color(0xFF0F172A);
  static const Color _mainBg = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _mainBg,
      body: Row(
        children: [
          // Restricted Sidebar
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
                  // Staff only sees Inventory and Profile
                  _buildSidebarItem(
                    0,
                    Icons.inventory_2_outlined,
                    'Inventory',
                    activeIcon: Icons.inventory_2,
                  ),
                  _buildSidebarItem(
                    1,
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

  Widget _buildMainContent() {
    if (_selectedIndex == 0) return const InventoryView();
    if (_selectedIndex == 1) return const ProfileView();
    return const SizedBox.shrink();
  }
}
