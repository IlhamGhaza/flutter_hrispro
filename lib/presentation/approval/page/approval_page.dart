import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../../../core/components/avatar.dart';
import '../../../data/datasource/mock_data_source.dart';
import '../bloc/approval_cubit.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApprovalCubit(),
      child: const _ApprovalView(),
    );
  }
}

class _ApprovalView extends StatelessWidget {
  const _ApprovalView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApprovalCubit, Map<int, String>>(
      builder: (context, handled) {
        final approvals = MockDataSource.approvals;
        final pending = approvals.length - handled.length;
        final approved = handled.values.where((s) => s == 'approved').length;
        final rejected = handled.values.where((s) => s == 'rejected').length;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(title: 'Approval Center', onBack: () => context.pop()),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStatCard('Pending', pending, AppColors.warning),
                    const SizedBox(width: 10),
                    _buildStatCard('Approved', approved, AppColors.success),
                    const SizedBox(width: 10),
                    _buildStatCard('Rejected', rejected, AppColors.error),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pending Requests',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'Tap to review',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...approvals.map((a) {
                  final status = handled[a.id];
                  return AnimatedOpacity(
                    opacity: status != null ? 0.6 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                          Row(
                            children: [
                              Avatar(initials: a.ini, size: AvatarSize.sm),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${a.empId} · ${a.dept}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(status: a.type),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.sub,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  a.detail,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '"${a.reason}"',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Submitted: ${a.time}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (status != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: status == 'approved'
                                    ? AppColors.successBg
                                    : AppColors.errorBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: status == 'approved'
                                      ? Colors.green.shade200
                                      : Colors.red.shade200,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                status == 'approved'
                                    ? '✓ Approved'
                                    : '✕ Rejected',
                                style: TextStyle(
                                  color: status == 'approved'
                                      ? AppColors.successText
                                      : AppColors.errorText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => context
                                        .read<ApprovalCubit>()
                                        .handleRequest(a.id, 'rejected'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                      side: BorderSide(
                                        color: Colors.red.shade200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.x, size: 13),
                                        SizedBox(width: 6),
                                        Text(
                                          'Reject',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<ApprovalCubit>()
                                        .handleRequest(a.id, 'approved'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(LucideIcons.check, size: 13),
                                        SizedBox(width: 6),
                                        Text(
                                          'Approve',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, int value, Color color) {
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
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
