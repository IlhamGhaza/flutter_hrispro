import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrispro/presentation/home/bloc/get_company/get_company_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../core/components/top_bar.dart';
import '../../../core/helper/radius_calculate.dart';
import '../bloc/check_in_cubit.dart';
import '../../home/bloc/checkin_attendance/checkin_attendance_bloc.dart';
import '../../home/bloc/checkout_attendance/checkout_attendance_bloc.dart';

class CheckInPage extends StatelessWidget {
  final bool isCheckIn;
  const CheckInPage({super.key, this.isCheckIn = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckInCubit(),
      child: BlocBuilder<GetCompanyBloc, GetCompanyState>(
        builder: (context, companyState) {
          final attendanceType = companyState.maybeWhen(
            success: (data) => data.attendanceType ?? 'hybrid',
            orElse: () => 'hybrid',
          ).toLowerCase();

          return _CheckInView(isCheckIn: isCheckIn, attendanceType: attendanceType);
        },
      ),
    );
  }
}

class _CheckInView extends StatefulWidget {
  final bool isCheckIn;
  final String attendanceType;
  const _CheckInView({required this.isCheckIn, required this.attendanceType});

  @override
  State<_CheckInView> createState() => _CheckInViewState();
}

class _CheckInViewState extends State<_CheckInView> {
  List<String> get _steps {
    if (widget.attendanceType == 'location_based_only') return ['GPS', 'Done'];
    if (widget.attendanceType == 'face_recognition_only' || widget.attendanceType == 'face') return ['Face ID', 'Done'];
    return ['GPS', 'Face ID', 'Done'];
  }

  Widget _buildStepIndicator(int currentStep) {
    final steps = _steps;
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
    // Removed the loading scaffold so it can render the full CheckInPage.

    return BlocBuilder<CheckInCubit, int>(
      builder: (context, step) {
        Widget bodyWidget;
        if (widget.attendanceType == 'location_based_only') {
          if (step == 0) {
            bodyWidget = _StepGPS(isCheckIn: widget.isCheckIn, hasFace: false);
          } else {
            bodyWidget = const _StepDone();
          }
        } else if (widget.attendanceType == 'face_recognition_only' || widget.attendanceType == 'face') {
          if (step == 0) {
            bodyWidget = _StepFaceOnlyLaunch(isCheckIn: widget.isCheckIn);
          } else {
            bodyWidget = const _StepDone();
          }
        } else {
          if (step == 0) {
            bodyWidget = _StepGPS(isCheckIn: widget.isCheckIn, hasFace: true);
          } else if (step == 1) {
            bodyWidget = const _StepFace();
          } else {
            bodyWidget = const _StepDone();
          }
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: TopBar(
            title: widget.isCheckIn ? 'Check In' : 'Check Out',
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
                child: bodyWidget,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepGPS extends StatefulWidget {
  final bool isCheckIn;
  final bool hasFace;
  const _StepGPS({required this.isCheckIn, required this.hasFace});

  @override
  State<_StepGPS> createState() => _StepGPSState();
}

class _StepGPSState extends State<_StepGPS> {
  bool _isLoading = true;
  bool _isValidLocation = false;
  Position? _currentPosition;
  double _distance = 0.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1. Get Company location from GetCompanyBloc
      final companyState = context.read<GetCompanyBloc>().state;
      companyState.maybeWhen(
        success: (data) async {
          final latPoint = double.tryParse(data.latitude ?? '0') ?? 0.0;
          final longPoint = double.tryParse(data.longitude ?? '0') ?? 0.0;
          final radiusPoint = double.tryParse(data.radiusKm ?? '0') ?? 0.0;

          // 2. Get Current Position
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            setState(() {
              _errorMessage = 'Location services are disabled.';
              _isLoading = false;
            });
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              setState(() {
                _errorMessage = 'Location permissions are denied';
                _isLoading = false;
              });
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            setState(() {
              _errorMessage = 'Location permissions are permanently denied.';
              _isLoading = false;
            });
            return;
          }

          final position = await Geolocator.getCurrentPosition();

          if (position.isMocked) {
            setState(() {
              _errorMessage = 'You are using fake location';
              _isLoading = false;
            });
            return;
          }

          // 3. Calculate distance
          final distance = RadiusCalculate.calculateDistance(
            position.latitude,
            position.longitude,
            latPoint,
            longPoint,
          );

          setState(() {
            _currentPosition = position;
            _distance = distance * 1000; // convert km to meters
            _isValidLocation = distance <= radiusPoint; // radius is already in km
            if (!_isValidLocation) {
              _errorMessage = 'You are outside the attendance area';
            }
            _isLoading = false;
          });
        },
        orElse: () {
          setState(() {
            _errorMessage = 'Failed to load company location';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

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
                  decoration: BoxDecoration(
                    color: _isLoading
                        ? Colors.grey.shade100
                        : _isValidLocation
                        ? AppColors.successBg
                        : Colors.red.shade50,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? Colors.grey.shade200
                              : _isValidLocation
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isLoading
                                ? Colors.grey.shade300
                                : _isValidLocation
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                            width: 4,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Icon(
                                _isValidLocation
                                    ? LucideIcons.mapPin
                                    : LucideIcons.alertTriangle,
                                color: _isValidLocation
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                size: 32,
                              ),
                      ),
                      const SizedBox(height: 12),
                      if (!_isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _isValidLocation
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            border: Border.all(
                              color: _isValidLocation
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _isValidLocation
                                ? '✓ Inside Office Radius'
                                : '✗ Outside Radius',
                            style: TextStyle(
                              color: _isValidLocation
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
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
                      Text(
                        _isLoading
                            ? 'Detecting...'
                            : _currentPosition != null
                            ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}'
                            : 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      const Text(
                        'STATUS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isLoading
                            ? 'Checking distance...'
                            : 'Distance: ${_distance.toStringAsFixed(1)}m',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _checkLocation,
                          child: const Text('Refresh Location'),
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
              onPressed: _isValidLocation && !_isLoading
                  ? () async {
                      if (widget.hasFace) {
                        final result = await context.push<bool>(
                          '/checkin/face',
                          extra: {
                            'isCheckIn': widget.isCheckIn,
                            'latitude': _currentPosition?.latitude,
                            'longitude': _currentPosition?.longitude,
                          },
                        );
                        if (result == true && mounted) {
                          context.read<CheckInCubit>().setStep(2); // Go to Done
                        }
                      } else {
                        // Location only -> Skip Face, submit attendance directly using Bloc
                        if (widget.isCheckIn) {
                          context.read<CheckinAttendanceBloc>().add(
                                CheckinAttendanceEvent.checkin(
                                  _currentPosition?.latitude.toString() ?? '0',
                                  _currentPosition?.longitude.toString() ?? '0',
                                ),
                              );
                        } else {
                          context.read<CheckoutAttendanceBloc>().add(
                                CheckoutAttendanceEvent.checkout(
                                  _currentPosition?.latitude.toString() ?? '0',
                                  _currentPosition?.longitude.toString() ?? '0',
                                ),
                              );
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: BlocConsumer<CheckinAttendanceBloc, CheckinAttendanceState>(
                listener: (context, state) {
                  state.whenOrNull(
                    loaded: (data) {
                      context.read<CheckInCubit>().nextStep(); // Go to Done
                    },
                    error: (msg) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
                    },
                  );
                },
                builder: (context, checkinState) {
                  return BlocConsumer<CheckoutAttendanceBloc, CheckoutAttendanceState>(
                    listener: (context, state) {
                      state.whenOrNull(
                        loaded: (data) {
                          context.read<CheckInCubit>().nextStep(); // Go to Done
                        },
                        error: (msg) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
                        },
                      );
                    },
                    builder: (context, checkoutState) {
                      final isSubmitting = checkinState.maybeWhen(loading: () => true, orElse: () => false) ||
                          checkoutState.maybeWhen(loading: () => true, orElse: () => false);

                      if (isSubmitting) {
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        );
                      }

                      return Text(
                        widget.hasFace ? 'Confirm Location & Continue →' : 'Submit Attendance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  );
                },
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

class _StepFaceOnlyLaunch extends StatelessWidget {
  final bool isCheckIn;
  const _StepFaceOnlyLaunch({required this.isCheckIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.scanFace, size: 80, color: AppColors.primary),
          const SizedBox(height: 24),
          const Text(
            'Face Verification Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your company requires face recognition for attendance. Please open the camera to verify your face.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final result = await context.push<bool>(
                  '/checkin/face',
                  extra: {
                    'isCheckIn': isCheckIn,
                    'latitude': 0.0,
                    'longitude': 0.0,
                  },
                );
                if (result == true && context.mounted) {
                  context.read<CheckInCubit>().setStep(1); // Go to Done
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Open Camera',
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
