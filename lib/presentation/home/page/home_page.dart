import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../Data/datasource/mock_data_source.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final emp = MockDataSource.emp;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopSection(context, emp)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Summary",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    //const SizedBox(height: 6),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.55,
                      children: [
                        _buildSummaryCard(
                          'Check In',
                          '08:02',
                          'On Time',
                          AppColors.success,
                        ),
                        _buildSummaryCard(
                          'Check Out',
                          '—:—',
                          'Pending',
                          AppColors.textSecondary,
                        ),
                        _buildSummaryCard(
                          'Work Hours',
                          '1h 39m',
                          'of 9h total',
                          AppColors.info,
                        ),
                        _buildSummaryCard(
                          'Overtime',
                          '0h',
                          'Not yet',
                          AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Stats',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildStatRow(
                            'Attendance Rate',
                            '96.4%',
                            LucideIcons.trendingUp,
                            AppColors.success,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _buildStatRow(
                            'Leave Balance',
                            '12 days',
                            LucideIcons.calendar,
                            AppColors.info,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _buildStatRow(
                            'Pending Requests',
                            '2',
                            LucideIcons.clipboardList,
                            AppColors.warning,
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _buildStatRow(
                            'Upcoming Holiday',
                            'Jul 17',
                            LucideIcons.zap,
                            AppColors.purple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.go('/approval'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              LucideIcons.users,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Approval Center',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '4 requests awaiting your review',
                                  style: TextStyle(
                                    color: AppColors.primaryLight,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            color: Colors.white.withValues(alpha: 0.50),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Announcements',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...MockDataSource.announcements.map((a) {
                      Color iconColor;
                      Color bgIconColor;
                      Color tagBgColor;
                      Color tagTextColor;
                      IconData icon;

                      if (a.tag == 'Holiday') {
                        iconColor = AppColors.error;
                        bgIconColor = AppColors.errorBg;
                        tagBgColor = AppColors.errorBg;
                        tagTextColor = AppColors.errorText;
                        icon = LucideIcons.zap;
                      } else if (a.tag == 'Policy') {
                        iconColor = AppColors.info;
                        bgIconColor = AppColors.infoBg;
                        tagBgColor = AppColors.infoBg;
                        tagTextColor = AppColors.infoText;
                        icon = LucideIcons.shield;
                      } else {
                        iconColor = AppColors.purple;
                        bgIconColor = AppColors.purpleBg;
                        tagBgColor = AppColors.purpleBg;
                        tagTextColor = AppColors.purpleText;
                        icon = LucideIcons.barChart2;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: bgIconColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Icon(icon, color: iconColor, size: 19),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagBgColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      a.tag,
                                      style: TextStyle(
                                        color: tagTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    a.title,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a.body,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, dynamic emp) {
    const double quickActionHeight = 290;
    const double overlapHeight = 26;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: overlapHeight + 18,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'IP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good Morning ☀️',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              emp.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${emp.position} · IT',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/notifications'),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                LucideIcons.bell,
                                color: Colors.white,
                                size: 24,
                              ),
                              Positioned(
                                top: 10,
                                right: 12,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            final now = DateTime.now();
                            final dateString = DateFormat('EEEE, MMMM d, y').format(now);
                            final timeString = DateFormat('HH:mm').format(now);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Today',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateString,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeString,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 31,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'WIB',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.55),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildAttCard('Schedule', '08:00–17:00'),
                            const SizedBox(width: 10),
                            _buildAttCard('Status', 'Present', highlight: true),
                            const SizedBox(width: 10),
                            _buildAttCard('Check In', '08:02 WIB'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: quickActionHeight - overlapHeight),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: SizedBox(
            height: quickActionHeight,
            child: _buildQuickActionsCard(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
              children: [
                _buildQuickAction(
                  context,
                  'Check In',
                  LucideIcons.checkCircle,
                  AppColors.success,
                  AppColors.successBg,
                  '/checkin',
                ),
                _buildQuickAction(
                  context,
                  'Check Out',
                  LucideIcons.xCircle,
                  AppColors.error,
                  AppColors.errorBg,
                  '/checkin',
                ),
                _buildQuickAction(
                  context,
                  'Leave',
                  LucideIcons.fileText,
                  AppColors.info,
                  AppColors.infoBg,
                  '/leave',
                ),
                _buildQuickAction(
                  context,
                  'Overtime',
                  LucideIcons.timer,
                  AppColors.warning,
                  AppColors.warningBg,
                  '/overtime',
                ),
                _buildQuickAction(
                  context,
                  'Correction',
                  LucideIcons.refreshCw,
                  AppColors.purple,
                  AppColors.purpleBg,
                  '/correction',
                ),
                _buildQuickAction(
                  context,
                  'Calendar',
                  LucideIcons.calendar,
                  const Color(0xFF06B6D4),
                  const Color(0xFFECFEFF),
                  '/calendar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttCard(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  color: highlight ? const Color(0xFF6EE7B7) : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Color bg,
    String route,
  ) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    String sub,
    Color subColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              // fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              // fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
