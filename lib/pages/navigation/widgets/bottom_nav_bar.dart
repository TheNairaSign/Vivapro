import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.homeOutline),
          activeIcon: Icon(EvaIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.activityOutline),
          activeIcon: Icon(EvaIcons.activity),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.messageCircleOutline),
          activeIcon: Icon(EvaIcons.messageCircle ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.personOutline),
          activeIcon: Icon(EvaIcons.person),
          label: 'Contacts',
        ),
      ],
    );
  }
}
