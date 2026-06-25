import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/colors.dart';
import '../../../Data/datasource/mock_data_source.dart';
import '../../../Data/model/response/models.dart';
import '../bloc/notifications_cubit.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final cats = ['All', 'HR', 'Attendance', 'Leave', 'Overtime', 'System'];
    final unread = MockDataSource.notifs.where((n) => !n.read).length;

    return BlocBuilder<NotificationsCubit, String>(
      builder: (context, cat) {
        final filtered = cat == 'All'
            ? MockDataSource.notifs
            : MockDataSource.notifs.where((n) => n.cat == cat).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 12),
            child: Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                bottom: 12,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      if (unread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '$unread',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mark all read',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: cats.map((c) {
                      final isActive = cat == c;
                      return GestureDetector(
                        onTap: () =>
                            context.read<NotificationsCubit>().setCat(c),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            c,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final n = filtered[index];
                    return _buildNotifCard(n);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotifCard(AppNotification n) {
    Color bg;
    Color text;
    if (n.cat == 'HR') {
      bg = AppColors.purpleBg;
      text = AppColors.purpleText;
    } else if (n.cat == 'Attendance') {
      bg = AppColors.infoBg;
      text = AppColors.infoText;
    } else if (n.cat == 'Leave') {
      bg = AppColors.successBg;
      text = AppColors.successText;
    } else if (n.cat == 'Overtime') {
      bg = AppColors.warningBg;
      text = AppColors.warningText;
    } else {
      bg = Colors.grey.shade100;
      text = Colors.grey.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: n.read
              ? AppColors.border
              : AppColors.info.withValues(alpha: 0.4),
        ),
        boxShadow: n.read
            ? null
            : [
                BoxShadow(
                  color: AppColors.info.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: n.read ? Colors.grey.shade200 : AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        n.cat,
                        style: TextStyle(
                          color: text,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      n.time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: n.read
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  n.msg,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
