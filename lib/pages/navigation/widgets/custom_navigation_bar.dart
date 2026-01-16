import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:ionicons/ionicons.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(context, 0, EvaIcons.homeOutline, Ionicons.home, "Home"),
                      _buildNavItem(context, 1,  EvaIcons.gridOutline, EvaIcons.grid, "Category"),
                      const SizedBox(width: 60), // Space for the Floating Action Button
                      _buildNavItem(
                        context,
                        2,
                        EvaIcons.heartOutline,
                        EvaIcons.heart,
                        "Wishlist"
                      ),
                      _buildNavItem(context, 3, EvaIcons.personOutline, EvaIcons.person, "Account"),
                    ],
                  ),    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600],
              size: 24,
            ),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
