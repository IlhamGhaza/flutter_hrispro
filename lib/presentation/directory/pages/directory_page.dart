import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';

class DirectoryPage extends StatelessWidget {
  const DirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: TopBar(
          title: 'Directory',
          onBack: () => context.pop(),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Employees'),
                  Tab(text: 'Org Chart'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmployeesTab(),
                  _buildOrgChartTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesTab() {
    // Mock list based on the API spec
    final employees = [
      {
        'name': 'Budi Santoso',
        'position': 'CEO',
        'department': 'Executive',
        'initials': 'BS',
        'color': AppColors.primary,
      },
      {
        'name': 'Sarah Widyana',
        'position': 'HR Manager',
        'department': 'Human Resources',
        'initials': 'SW',
        'color': AppColors.warning,
      },
      {
        'name': 'Reza Firmansyah',
        'position': 'Mobile Developer',
        'department': 'Engineering',
        'initials': 'RF',
        'color': AppColors.info,
      },
      {
        'name': 'Ayu Lestari',
        'position': 'UI/UX Designer',
        'department': 'Design',
        'initials': 'AL',
        'color': AppColors.purple,
      }
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final emp = employees[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (emp['color'] as Color).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  emp['initials'] as String,
                  style: TextStyle(
                    color: emp['color'] as Color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emp['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${emp['position']} • ${emp['department']}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(LucideIcons.messageSquare, color: AppColors.primary, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrgChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildOrgCard('Budi Santoso', 'CEO', AppColors.primary),
          Container(
            width: 2,
            height: 30,
            color: AppColors.border,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      color: AppColors.border,
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: AppColors.border,
                    ),
                    _buildOrgCard('Sarah Widyana', 'HR Manager', AppColors.warning),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      color: AppColors.border,
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      color: AppColors.border,
                    ),
                    _buildOrgCard('Reza Firmansyah', 'Tech Lead', AppColors.info),
                    Container(
                      width: 2,
                      height: 30,
                      color: AppColors.border,
                    ),
                    _buildOrgCard('Ayu Lestari', 'UI/UX', AppColors.purple),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrgCard(String name, String position, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            position,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
