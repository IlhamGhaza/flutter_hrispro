import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../Data/datasource/mock_data_source.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emp = MockDataSource.emp;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 40,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          LucideIcons.edit,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 3,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'IP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    emp.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    emp.position,
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    emp.dept,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      emp.id,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _buildInfoItem(
                    LucideIcons.mail,
                    'Email',
                    'ilham.p@company.com',
                  ),
                  _buildInfoItem(
                    LucideIcons.phone,
                    'Phone',
                    '+62 812-3456-7890',
                  ),
                  _buildInfoItem(LucideIcons.building2, 'Dept', 'IT Dept'),
                  _buildInfoItem(LucideIcons.shield, 'Role', emp.role),
                  _buildInfoItem(
                    LucideIcons.calendar,
                    'Joined',
                    'Mar 15, 2021',
                  ),
                  _buildInfoItem(
                    LucideIcons.clipboardList,
                    'Leave Balance',
                    '12 days',
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _buildActionItem(
                      LucideIcons.edit,
                      'Edit Profile',
                      AppColors.info,
                    ),
                    const Divider(height: 1),
                    _buildActionItem(
                      LucideIcons.shield,
                      'Change Password',
                      AppColors.purple,
                    ),
                    const Divider(height: 1),
                    _buildActionItem(
                      LucideIcons.camera,
                      'Face Registration',
                      AppColors.success,
                    ),
                    const Divider(height: 1),
                    _buildActionItem(
                      LucideIcons.bell,
                      'Notification Settings',
                      AppColors.warning,
                    ),
                    const Divider(height: 1),
                    _buildActionItem(
                      LucideIcons.users,
                      'Approval Delegates',
                      const Color(0xFF06B6D4),
                    ),
                    const Divider(height: 1),
                    _buildActionItem(
                      LucideIcons.settings,
                      'App Settings',
                      AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.logOut,
                      color: Colors.red.shade500,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.red.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.primary, size: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Colors.grey.shade300,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
