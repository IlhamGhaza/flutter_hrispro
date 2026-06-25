import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../../../Data/datasource/mock_data_source.dart';
import '../bloc/history_cubit.dart';

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

class _HistoryView extends StatelessWidget {
  const _HistoryView();

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
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _getItemCount(tab),
                  itemBuilder: (context, index) => _buildItem(tab, index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getItemCount(HistoryTab tab) {
    if (tab == HistoryTab.attendance) return MockDataSource.attendance.length;
    if (tab == HistoryTab.leave) return MockDataSource.leaves.length;
    return MockDataSource.overtime.length;
  }

  Widget _buildItem(HistoryTab tab, int index) {
    if (tab == HistoryTab.attendance) {
      final a = MockDataSource.attendance[index];
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.date,
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
                        Text(
                          a.loc,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge(status: a.status),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAttStat('CHECK IN', a.inn),
                const SizedBox(width: 20),
                _buildAttStat('CHECK OUT', a.out),
                const SizedBox(width: 20),
                _buildAttStat('DURATION', a.hrs),
              ],
            ),
          ],
        ),
      );
    } else if (tab == HistoryTab.leave) {
      final l = MockDataSource.leaves[index];
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
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    } else {
      final o = MockDataSource.overtime[index];
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
                  o.project,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                StatusBadge(status: o.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${o.date} · ${o.start} – ${o.end}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${o.hrs} overtime',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
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
