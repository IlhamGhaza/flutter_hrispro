import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../constant/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? rightWidget;

  const TopBar({super.key, required this.title, this.onBack, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.chevronLeft,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (rightWidget != null) rightWidget!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
}
