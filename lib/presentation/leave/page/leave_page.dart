import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrispro/presentation/leave/bloc/leave_balance/leave_balance_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import 'package:intl/intl.dart';
import '../bloc/leave_cubit.dart';
import '../bloc/get_all_leaves/get_all_leaves_bloc.dart';
import '../bloc/leave_type/leave_type_bloc.dart';
import 'add_leave_form.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LeaveCubit(), child: const _LeaveView());
  }
}

class _LeaveView extends StatefulWidget {
  const _LeaveView();

  @override
  State<_LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<_LeaveView> {
  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    }
    return _dateFormatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    context.read<GetAllLeavesBloc>().add(
      const GetAllLeavesEvent.getAllLeaves(),
    );
    context.read<LeaveTypeBloc>().add(const LeaveTypeEvent.getLeaveTypes());
    context.read<LeaveBalanceBloc>().add(
      const LeaveBalanceEvent.getLeaveBalance(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveCubit, bool>(
      builder: (context, showForm) {
        if (showForm) {
          return const AddLeaveForm();
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
                BlocBuilder<LeaveTypeBloc, LeaveTypeState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const SizedBox.shrink(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (msg) => const SizedBox.shrink(),
                      success: (leaveTypesData) {
                        final leaveTypes = leaveTypesData.data ?? [];
                        if (leaveTypes.isEmpty) {
                          return const Text('No leave balances available');
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: leaveTypes.asMap().entries.map((entry) {
                              final index = entry.key;
                              final type = entry.value;

                              // Determine colors based on index
                              final colors = [
                                (AppColors.info, AppColors.infoBg),
                                (AppColors.success, AppColors.successBg),
                                (AppColors.purple, AppColors.purpleBg),
                                (AppColors.warning, AppColors.warningBg),
                              ];

                              final colorPair = colors[index % colors.length];

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _buildBalanceCard(
                                  type.name ?? 'Leave',
                                  type.quotaDays ?? 0,
                                  colorPair.$1,
                                  colorPair.$2,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Request History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                BlocBuilder<GetAllLeavesBloc, GetAllLeavesState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const SizedBox.shrink(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (msg) => Center(child: Text(msg)),
                      success: (leavesData) {
                        final leaves = leavesData.data ?? [];
                        if (leaves.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No leave records yet',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: leaves.map((l) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l.leaveType?.name ?? 'Leave',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      StatusBadge(
                                        status: l.status ?? 'pending',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_formatDate(l.startDate)} – ${_formatDate(l.endDate)} · ${l.totalDays ?? 0} day${(l.totalDays ?? 0) > 1 ? "s" : ""}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '"${l.reason ?? ''}"',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
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
