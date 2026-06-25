import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../../../Data/datasource/mock_data_source.dart';
import '../bloc/leave_cubit.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LeaveCubit(), child: const _LeaveView());
  }
}

class _LeaveView extends StatelessWidget {
  const _LeaveView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveCubit, bool>(
      builder: (context, showForm) {
        if (showForm) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: TopBar(
              title: 'New Leave Request',
              onBack: () => context.read<LeaveCubit>().toggleForm(false),
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
                          'Leave Type',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: 'Annual Leave',
                              items:
                                  [
                                        'Annual Leave',
                                        'Sick Leave',
                                        'Special Leave',
                                      ]
                                      .map(
                                        (t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(
                                            t,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {},
                            ),
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
                                    'Start Date',
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
                                      '2026-06-25',
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
                                    'End Date',
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
                                      '2026-06-27',
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
                            color: AppColors.infoBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                LucideIcons.alertCircle,
                                size: 14,
                                color: AppColors.info,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Duration: 3 working days · Remaining balance: 12 days',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
                              hintText:
                                  'Briefly describe your reason for leave...',
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
                        RichText(
                          text: const TextSpan(
                            text: 'Supporting Document ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              TextSpan(
                                text: '(optional)',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                              style: BorderStyle.solid,
                            ), // No dotted border easy natively, use solid
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                LucideIcons.fileText,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Tap to upload document',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'PDF, JPG or PNG · Max 5MB',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
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
                          context.read<LeaveCubit>().toggleForm(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Leave Request',
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
            title: 'Leave Management',
            onBack: () => context.pop(),
            rightWidget: GestureDetector(
              onTap: () => context.read<LeaveCubit>().toggleForm(true),
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
                Row(
                  children: [
                    _buildBalanceCard(
                      'Annual',
                      12,
                      AppColors.info,
                      AppColors.infoBg,
                    ),
                    const SizedBox(width: 10),
                    _buildBalanceCard(
                      'Sick',
                      6,
                      AppColors.success,
                      AppColors.successBg,
                    ),
                    const SizedBox(width: 10),
                    _buildBalanceCard(
                      'Special',
                      4,
                      AppColors.purple,
                      AppColors.purpleBg,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Request History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ...MockDataSource.leaves.map((l) {
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
                            Text(
                              l.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            StatusBadge(status: l.status),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l.start} – ${l.end} · ${l.days} day${l.days > 1 ? "s" : ""}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${l.reason}"',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<LeaveCubit>().toggleForm(true),
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
                          'New Leave Request',
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

  Widget _buildBalanceCard(String type, int days, Color color, Color bg) {
    return Expanded(
      child: Container(
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
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(LucideIcons.calendar, color: color, size: 14),
            ),
            const SizedBox(height: 6),
            Text(
              '$days',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              '$type\nLeave',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
