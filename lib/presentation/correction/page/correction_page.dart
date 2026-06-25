import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/components/status_badge.dart';
import '../bloc/correction_cubit.dart';

class CorrectionPage extends StatelessWidget {
  const CorrectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CorrectionCubit(),
      child: const _CorrectionView(),
    );
  }
}

class _CorrectionView extends StatelessWidget {
  const _CorrectionView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorrectionCubit, bool>(
      builder: (context, showForm) {
        if (showForm) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: TopBar(
              title: 'New Correction',
              onBack: () => context.read<CorrectionCubit>().toggleForm(false),
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
                          'Attendance Date',
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
                            '2026-06-15',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Correction Type',
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
                              value: 'Forgot Check In',
                              items:
                                  [
                                        'Forgot Check In',
                                        'Forgot Check Out',
                                        'GPS Failure',
                                        'Face Recognition Failure',
                                        'Business Trip',
                                        'Emergency',
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
                        const Text(
                          'Explanation',
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
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText:
                                  'Please describe what happened in detail...',
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
                            border: Border.all(color: AppColors.border),
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
                          context.read<CorrectionCubit>().toggleForm(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Correction Request',
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

        final history = [
          {
            'date': 'Jun 15, 2026',
            'type': 'Forgot Check In',
            'status': 'Approved',
            'submitted': 'Jun 15, 14:00',
          },
          {
            'date': 'May 20, 2026',
            'type': 'GPS Failure',
            'status': 'Approved',
            'submitted': 'May 20, 16:30',
          },
          {
            'date': 'Apr 8, 2026',
            'type': 'Forgot Check Out',
            'status': 'Rejected',
            'submitted': 'Apr 9, 09:15',
          },
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(
            title: 'Attendance Correction',
            onBack: () => context.pop(),
            rightWidget: GestureDetector(
              onTap: () => context.read<CorrectionCubit>().toggleForm(true),
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
                    color: AppColors.purpleBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE9D5FF),
                    ), // purple-100
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          LucideIcons.alertCircle,
                          color: AppColors.purple,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'When to use this?',
                              style: TextStyle(
                                color: Colors.purple.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Submit a correction if you forgot to check in/out, had GPS or face recognition issues, or attended a business trip.',
                              style: TextStyle(
                                color: Colors.purple.shade600,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Correction History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ...history.map((c) {
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
                              c['type']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            StatusBadge(status: c['status']!),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c['date']!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Submitted: ${c['submitted']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
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
                        context.read<CorrectionCubit>().toggleForm(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
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
                          'New Correction Request',
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
}
