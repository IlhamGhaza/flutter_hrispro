import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../bloc/check_in_cubit.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckInCubit(),
      child: const _CheckInView(),
    );
  }
}

class _CheckInView extends StatelessWidget {
  const _CheckInView();

  Widget _buildStepIndicator(int currentStep) {
    final steps = ['GPS', 'Face ID', 'Done'];
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isPast = i < currentStep;
          final isCurrent = i == currentStep;

          Color bgColor;
          Color textColor;
          if (isPast) {
            bgColor = AppColors.success;
            textColor = Colors.white;
          } else if (isCurrent) {
            bgColor = Colors.white;
            textColor = AppColors.primary;
          } else {
            bgColor = Colors.white.withValues(alpha: 0.2);
            textColor = Colors.white.withValues(alpha: 0.5);
          }

          return Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isPast
                    ? const Icon(
                        LucideIcons.check,
                        color: Colors.white,
                        size: 11,
                      )
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 4),
              Text(
                steps[i],
                style: TextStyle(
                  color: isPast || isCurrent
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (i < steps.length - 1)
                Container(
                  width: 24,
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  color: isPast
                      ? AppColors.success
                      : Colors.white.withValues(alpha: 0.2),
                ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInCubit, int>(
      builder: (context, step) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(
            title: 'Check In',
            onBack: step == 0
                ? () => context.pop()
                : (step == 1
                      ? () => context.read<CheckInCubit>().prevStep()
                      : null),
          ),
          body: Column(
            children: [
              _buildStepIndicator(step),
              Expanded(
                child: step == 0
                    ? const _StepGPS()
                    : (step == 1 ? const _StepFace() : const _StepDone()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepGPS extends StatelessWidget {
  const _StepGPS();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          LucideIcons.mapPin,
                          color: Colors.green.shade600,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          border: Border.all(color: Colors.green.shade200),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '✓ Inside Office Radius',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YOUR LOCATION',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Jl. Jend. Sudirman Kav. 21, Jakarta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        '−6.2088° S, 106.8456° E',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      const Text(
                        'VERIFIED OFFICE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Main Office – PT. Nusantara HQ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Distance: 42m · within 200m radius',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      const Text(
                        'WORK LOCATION TYPE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Main Office', 'WFH', 'Branch', 'Remote']
                            .map((loc) {
                              final isMain = loc == 'Main Office';
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isMain
                                      ? AppColors.primary
                                      : Colors.white,
                                  border: Border.all(
                                    color: isMain
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  loc,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isMain
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              );
                            })
                            .toList(),
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
              onPressed: () => context.read<CheckInCubit>().nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm Location & Continue →',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepFace extends StatelessWidget {
  const _StepFace();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Position your face within the frame',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.info, width: 3),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.user,
                      color: Colors.blueGrey.shade400,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Scanning…',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildCheck('Liveness Detection', true),
                const SizedBox(height: 10),
                _buildCheck('Face Matched', true),
                const SizedBox(height: 10),
                _buildCheck('Single Face Detected', true),
                const SizedBox(height: 10),
                _buildCheck('Lighting Adequate', true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.read<CheckInCubit>().nextStep(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm Check In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheck(String label, bool ok) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: ok ? Colors.green.shade100 : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: ok
              ? Icon(LucideIcons.check, color: Colors.green.shade600, size: 12)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ok ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StepDone extends StatelessWidget {
  const _StepDone();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.checkCircle,
              color: Colors.green.shade500,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Check In Successful!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your attendance has been recorded',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildRow('Check In Time', '08:02 WIB'),
                const SizedBox(height: 12),
                _buildRow('Date', 'Monday, June 22, 2026'),
                const SizedBox(height: 12),
                _buildRow('Location', 'Main Office – HQ'),
                const SizedBox(height: 12),
                _buildRow('Work Schedule', '08:00 – 17:00'),
                const SizedBox(height: 12),
                _buildRow('Status', 'Present (On Time) ✓'),
                const SizedBox(height: 12),
                _buildRow('Verified via', 'GPS + Face Recognition'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/history'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Attendance History',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
