import 'package:flutter/material.dart';
import 'package:alcipen/config/routes.dart';
import 'package:alcipen/config/theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isWriter;

  const AppBottomNav({
    Key? key,
    required this.currentIndex,
    this.isWriter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
                index: 0,
                route: isWriter ? '/writer-dashboard' : '/seeker-home',
              ),
              _buildNavItem(
                context,
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                label: 'Chats',
                index: 1,
                route: '/chat',
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today_outlined,
                selectedIcon: Icons.calendar_today,
                label: 'Schedule',
                index: 2,
                route: '/schedule-handover',
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
                index: 3,
                route: isWriter ? '/writer-profile-settings' : '/seeker-profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? isWriter ? AppColors.accentPurple : AppColors.primaryBlue
        : AppColors.grey;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          AppRoutes.navigateAndRemoveUntil(context, route);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}