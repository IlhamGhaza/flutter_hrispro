import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/auth_local_datasource.dart';
import '../../auth/bloc/logout/logout_bloc.dart';

import '../bloc/get_user/get_user_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<GetUserBloc>().add(const GetUserEvent.getUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<GetUserBloc, GetUserState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.red)),
            ),
            success: (user) {
              final name = user.name ?? 'Unknown';
              final initials = name.isNotEmpty
                  ? name.substring(0, 1).toUpperCase()
                  : '?';
              final department = user.department ?? 'No Department';
              final position = user.position ?? 'No Position';

              return CustomScrollView(
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
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    LucideIcons.bell,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    context.push('/notifications');
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 3,
                                  ),
                                  image: user.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(user.imageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: user.imageUrl == null
                                    ? Center(
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$position • $department',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.success.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.checkCircle2,
                                            color: AppColors.success,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Active Employee',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            user.email ?? '-',
                          ),
                          _buildInfoItem(
                            LucideIcons.phone,
                            'Phone',
                            user.phone ?? '-',
                          ),
                          _buildInfoItem(
                            LucideIcons.building2,
                            'Dept',
                            department,
                          ),
                          _buildInfoItem(
                            LucideIcons.shield,
                            'Role',
                            user.role ?? 'Employee',
                          ),
                          _buildInfoItem(
                            LucideIcons.calendar,
                            'Joined',
                            user.createdAt != null
                                ? user.createdAt!.toString().substring(0, 10)
                                : '-',
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
                              onTap: () {
                                context.push('/update-profile', extra: user);
                              },
                            ),
                            const Divider(height: 1),
                            _buildActionItem(
                              LucideIcons.shield,
                              'Change Password',
                              AppColors.purple,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Under Maintenance',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: AppColors.warning,
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            // _buildActionItem(
                            //   LucideIcons.camera,
                            //   'Face Registration',
                            //   AppColors.success,
                            // ),
                            // const Divider(height: 1),
                            _buildActionItem(
                              LucideIcons.bell,
                              'Notification Settings',
                              AppColors.warning,
                              onTap: () {
                                context.push('/notification-settings');
                              },
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
                              onTap: () {
                                context.push('/app-settings');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: BlocConsumer<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            orElse: () {},
                            success: () {
                              AuthLocalDatasource().removeAuthData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout success!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                              context.go('/login');
                            },
                            error: (message) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return ElevatedButton(
                                onPressed: () {
                                  context.read<LogoutBloc>().add(
                                    const LogoutEvent.logout(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.red.shade200,
                                    ),
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
                              );
                            },
                            loading: () {
                              return ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              );
            },
          );
        },
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

  Widget _buildActionItem(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
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
