import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../bloc/history_cubit.dart';
import '../bloc/get_all_attendances/get_all_attendances_bloc.dart';
import '../../../data/model/response/attendance_response_model.dart';
import '../../leave/bloc/get_all_leaves/get_all_leaves_bloc.dart';
import '../../../data/model/response/leave_response_model.dart';
import '../../overtime/bloc/get_overtimes/get_overtimes_bloc.dart';
import '../../../data/model/response/overtime_response_model.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  String _selectedFilter = 'All';
  String _leaveFilter = 'All';
  String _overtimeFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<GetAllAttendancesBloc>().add(
      const GetAllAttendancesEvent.getAllAttendances(),
    );
    context.read<GetAllLeavesBloc>().add(
      const GetAllLeavesEvent.getAllLeaves(),
    );
    context.read<GetOvertimesBloc>().add(
      const GetOvertimesEvent.getOvertimes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryTab>(
      builder: (context, tab) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const TopBar(title: 'History'),
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: HistoryTab.values.map((t) {
                    final isActive = tab == t;
                    final label = t.name[0].toUpperCase() + t.name.substring(1);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => context.read<HistoryCubit>().setTab(t),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isActive
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              LucideIcons.search,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: 'Search records...',
                                  hintStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        LucideIcons.filter,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (tab == HistoryTab.attendance)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildAttendanceFilterChip('All', _selectedFilter == 'All'),
                        const SizedBox(width: 8),
                        _buildAttendanceFilterChip('Present', _selectedFilter == 'Present'),
                        const SizedBox(width: 8),
                        _buildAttendanceFilterChip('Late', _selectedFilter == 'Late'),
                        const SizedBox(width: 8),
                        _buildAttendanceFilterChip('Absent', _selectedFilter == 'Absent'),
                      ],
                    ),
                  ),
                )
              else if (tab == HistoryTab.leave)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildLeaveFilterChip('All', _leaveFilter == 'All'),
                        const SizedBox(width: 8),
                        _buildLeaveFilterChip('Pending', _leaveFilter == 'Pending'),
                        const SizedBox(width: 8),
                        _buildLeaveFilterChip('Approved', _leaveFilter == 'Approved'),
                        const SizedBox(width: 8),
                        _buildLeaveFilterChip('Rejected', _leaveFilter == 'Rejected'),
                      ],
                    ),
                  ),
                )
              else if (tab == HistoryTab.overtime)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildOvertimeFilterChip('All', _overtimeFilter == 'All'),
                        const SizedBox(width: 8),
                        _buildOvertimeFilterChip('Pending', _overtimeFilter == 'Pending'),
                        const SizedBox(width: 8),
                        _buildOvertimeFilterChip('Approved', _overtimeFilter == 'Approved'),
                        const SizedBox(width: 8),
                        _buildOvertimeFilterChip('Rejected', _overtimeFilter == 'Rejected'),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: tab == HistoryTab.attendance
                    ? BlocBuilder<
                        GetAllAttendancesBloc,
                        GetAllAttendancesState
                      >(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (msg) => Center(child: Text(msg)),
                            empty: () => const Center(
                              child: Text('No attendance data available'),
                            ),
                            loaded: (attendances) {
                              var filtered = attendances;
                              if (_selectedFilter == 'Late') {
                                filtered = attendances.where((a) => (a.lateMinutes ?? 0) > 0).toList();
                              } else if (_selectedFilter == 'Present') {
                                filtered = attendances.where((a) => (a.timeIn ?? '').isNotEmpty).toList();
                              } else if (_selectedFilter == 'Absent') {
                                filtered = attendances.where((a) => (a.timeIn ?? '').isEmpty).toList();
                              }

                              if (filtered.isEmpty) {
                                return const Center(
                                  child: Text('No attendance data for this filter'),
                                );
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) =>
                                    _buildAttendanceItem(filtered[index]),
                              );
                            },
                          );
                        },
                      )
                    : tab == HistoryTab.leave
                    ? BlocBuilder<GetAllLeavesBloc, GetAllLeavesState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (msg) => Center(child: Text(msg)),
                            success: (leavesData) {
                              var leaves = leavesData.data ?? [];
                              
                              if (_leaveFilter != 'All') {
                                leaves = leaves.where((l) => (l.status ?? '').toLowerCase() == _leaveFilter.toLowerCase()).toList();
                              }

                              if (leaves.isEmpty) {
                                return const Center(
                                  child: Text('No leave data for this filter'),
                                );
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: leaves.length,
                                itemBuilder: (context, index) =>
                                    _buildLeaveItem(leaves[index]),
                              );
                            },
                          );
                        },
                      )
                    : BlocBuilder<GetOvertimesBloc, GetOvertimesState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (msg) => Center(child: Text(msg)),
                            loaded: (overtimesData) {
                              var overtimes = overtimesData;
                              
                              if (_overtimeFilter != 'All') {
                                overtimes = overtimes.where((o) => (o.status ?? '').toLowerCase() == _overtimeFilter.toLowerCase()).toList();
                              }

                              if (overtimes.isEmpty) {
                                return const Center(
                                  child: Text('No overtime data for this filter'),
                                );
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: overtimes.length,
                                itemBuilder: (context, index) =>
                                    _buildOvertimeItem(overtimes[index]),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _leaveFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOvertimeFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _overtimeFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(Attendance attendance) {
    final dateFormatter = DateFormat('EEE, dd MMM yyyy');
    final formattedDate = attendance.date != null
        ? dateFormatter.format(attendance.date!)
        : 'Unknown Date';
    final timeIn = attendance.timeIn ?? '--:--';
    final timeOut = attendance.timeOut ?? '--:--';
    int lateMin = attendance.lateMinutes ?? 0;
    String dur = lateMin > 0 ? '${lateMin} min late' : 'On Time';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.mapPin,
                          size: 10,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Office',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: attendance.status ?? ''),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _buildAttStat('CHECK IN', timeIn),
              _buildAttStat('CHECK OUT', timeOut),
              _buildAttStat('INFO', dur),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveItem(Leave l) {
    final dateFormatter = DateFormat('EEE, dd MMM yyyy');
    final startDateStr = l.startDate != null
        ? dateFormatter.format(l.startDate!)
        : '-';
    final endDateStr = l.endDate != null
        ? dateFormatter.format(l.endDate!)
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
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
              StatusBadge(status: l.status ?? 'pending'),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$startDateStr - $endDateStr · ${l.totalDays ?? 0} day${(l.totalDays ?? 0) > 1 ? "s" : ""}',
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
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOvertimeItem(Overtime o) {
    final dateFormatter = DateFormat('EEE, dd MMM yyyy');
    final dateStr = o.date != null
        ? dateFormatter.format(DateTime.parse(o.date!))
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Overtime',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
            '$dateStr · ${o.startTime ?? '--:--'} - ${o.endTime ?? '--:--'}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          if (o.reason != null && o.reason!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '"${o.reason}"',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ],
    );
  }
}
