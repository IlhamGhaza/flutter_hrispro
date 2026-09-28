import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../bloc/overtime_cubit.dart';
import '../bloc/get_overtimes/get_overtimes_bloc.dart';
import 'package:intl/intl.dart';

class OvertimePage extends StatelessWidget {
  const OvertimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OvertimeCubit(),
      child: const _OvertimeView(),
    );
  }
}

class _OvertimeView extends StatefulWidget {
  const _OvertimeView();

  @override
  State<_OvertimeView> createState() => _OvertimeViewState();
}

class _OvertimeViewState extends State<_OvertimeView> {
  final DateFormat _dateFormatter = DateFormat('EEE, dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    context.read<GetOvertimesBloc>().add(
      const GetOvertimesEvent.getOvertimes(),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      return _dateFormatter.format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  String _calculateHrs(String? start, String? end) {
    if (start == null || end == null || start.isEmpty || end.isEmpty) return '-';
    try {
      final startTime = DateFormat('HH:mm:ss').parse(start);
      final endTime = DateFormat('HH:mm:ss').parse(end);
      final diff = endTime.difference(startTime);
      final hrs = diff.inMinutes / 60.0;
      return '${hrs.toStringAsFixed(1)}h';
    } catch (_) {
      try {
        final startTime = DateFormat('HH:mm').parse(start);
        final endTime = DateFormat('HH:mm').parse(end);
        final diff = endTime.difference(startTime);
        final hrs = diff.inMinutes / 60.0;
        return '${hrs.toStringAsFixed(1)}h';
      } catch (_) {
        return '-';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OvertimeCubit, bool>(
      builder: (context, showForm) {
        if (showForm) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: TopBar(
              title: 'New Overtime Request',
              onBack: () => context.read<OvertimeCubit>().toggleForm(false),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Text(
                            '2026-06-22',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: const Text(
                                      '17:00',
                                      style: TextStyle(fontSize: 14),
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
                                  const Text(
                                    'End Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: const Text(
                                      '20:00',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.timer,
                                size: 14,
                                color: Colors.orange.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Estimated: 3 hours overtime',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Project / Task',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'e.g. Mobile App v2.0 deployment',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Reason',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const TextField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Explain why overtime is required...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<OvertimeCubit>().toggleForm(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Overtime Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(
            title: 'Overtime',
            onBack: () => context.pop(),
            rightWidget: GestureDetector(
              onTap: () => context.read<OvertimeCubit>().toggleForm(true),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.plus,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                        'THIS MONTH',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '9.5 hrs',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat('APPROVED', '7h', AppColors.success),
                          _buildStat('PENDING', '2.5h', AppColors.warning),
                          _buildStat('SESSIONS', '2', AppColors.info),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Request History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                BlocBuilder<GetOvertimesBloc, GetOvertimesState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Center(child: CircularProgressIndicator()),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (msg) => Center(child: Text(msg)),
                      loaded: (overtimesData) {
                        final overtimes = overtimesData;
                        if (overtimes.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No overtime records yet',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: overtimes.map((o) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          o.reason ?? 'Overtime',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      StatusBadge(status: o.status ?? 'pending'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_formatDate(o.date)} · ${o.startTime ?? '--:--'} – ${o.endTime ?? '--:--'}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${_calculateHrs(o.startTime, o.endTime)} overtime',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<OvertimeCubit>().toggleForm(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.plus, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'New Overtime Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
