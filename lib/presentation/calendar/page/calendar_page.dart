import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../bloc/calendar_cubit.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit(),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    final statusDot = <int, Color>{
      1: AppColors.success,
      2: AppColors.success,
      3: AppColors.success,
      4: AppColors.success,
      5: AppColors.success,
      8: AppColors.success,
      9: AppColors.success,
      10: AppColors.info,
      11: AppColors.info,
      12: AppColors.info,
      15: Colors.red.shade400,
      16: AppColors.success,
      17: AppColors.success,
      18: AppColors.warning,
      19: AppColors.success,
      22: Colors.blue.shade400,
    };

    final weekends = {6, 7, 13, 14, 20, 21, 27, 28};
    final dayHeaders = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return BlocBuilder<CalendarCubit, CalendarMode>(
      builder: (context, mode) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(
            title: 'Calendar',
            onBack: () => context.pop(),
            rightWidget: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: CalendarMode.values.map((m) {
                  final isActive = mode == m;
                  return GestureDetector(
                    onTap: () => context.read<CalendarCubit>().setMode(m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        m.name[0].toUpperCase() + m.name.substring(1),
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'June 2026',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              _buildNavBtn(LucideIcons.chevronLeft),
                              const SizedBox(width: 8),
                              _buildNavBtn(LucideIcons.chevronRight),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          7,
                          (i) => Expanded(
                            child: Text(
                              dayHeaders[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: i >= 5
                                    ? Colors.red.shade400
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1,
                            ),
                        itemCount: 30,
                        itemBuilder: (context, idx) {
                          final day = idx + 1;
                          final isToday = day == 22;
                          final isWeekend = weekends.contains(day);
                          final dot = statusDot[day];

                          return Container(
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isToday
                                        ? Colors.white
                                        : (isWeekend
                                              ? Colors.red.shade400
                                              : AppColors.textPrimary),
                                  ),
                                ),
                                if (dot != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isToday
                                          ? Colors.white.withValues(alpha: 0.6)
                                          : dot,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LEGEND',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLegendItem(
                                    'Present',
                                    AppColors.success,
                                  ),
                                ),
                                Expanded(
                                  child: _buildLegendItem(
                                    'Late',
                                    AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLegendItem(
                                    'Leave',
                                    AppColors.info,
                                  ),
                                ),
                                Expanded(
                                  child: _buildLegendItem(
                                    'Absent / Holiday',
                                    Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        'JUN',
                        '22',
                        'Today · Work Day',
                        'Schedule: 08:00 – 17:00',
                        AppColors.info,
                      ),
                      _buildEventCard(
                        'JUN',
                        '25',
                        'Leave: Reza Firmansyah',
                        'Annual Leave · IT Team',
                        AppColors.success,
                      ),
                      _buildEventCard(
                        'JUN',
                        '27',
                        'System Maintenance',
                        '22:00 – 02:00 downtime',
                        AppColors.textSecondary,
                      ),
                      _buildEventCard(
                        'JUL',
                        '17',
                        'Independence Day',
                        'National Holiday · Office Closed',
                        AppColors.error,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavBtn(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 14, color: AppColors.textSecondary),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    String month,
    String day,
    String event,
    String desc,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    color: color,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  day,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
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
