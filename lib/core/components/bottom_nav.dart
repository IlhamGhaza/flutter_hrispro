import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../constant/colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': LucideIcons.home, 'label': 'Home'},
      {'icon': LucideIcons.clock, 'label': 'History'},
      {'icon': LucideIcons.bell, 'label': 'Alerts'},
      {'icon': LucideIcons.user, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final isActive = currentIndex == index;
            final item = items[index];
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: isActive
                              ? AppColors.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppColors.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
