import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/theme/global_colors.dart';

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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // The black pill background
          GlassContainer(
            height: 70,
            border: Border.fromBorderSide(BorderSide.none),
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(40),
            // decoration: BoxDecoration(
            //   color: GlobalColors.navBarBlack,
            //   borderRadius: BorderRadius.circular(40),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withValues(alpha: 0.15),
            //       blurRadius: 20,
            //       offset: const Offset(0, 10),
            //     ),
            //   ],
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Ionicons.heart_outline, Ionicons.heart),
                _buildNavItem(1, Ionicons.time_outline, Ionicons.time),
                const SizedBox(width: 60), // Space for the center button
                _buildNavItem(3, Ionicons.chatbubble_outline, Ionicons.chatbubble),
                _buildNavItem(4, Ionicons.person_outline, Ionicons.person),
              ],
            ),
          ),
          // The Floating Action Button
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => onItemSelected(2),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(
          isSelected ? filledIcon : outlineIcon,
          color: isSelected ? Colors.lightBlue : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}