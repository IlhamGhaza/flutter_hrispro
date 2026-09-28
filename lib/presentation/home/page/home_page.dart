import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../Data/datasource/mock_data_source.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/bloc/get_user/get_user_bloc.dart';
import '../bloc/get_company/get_company_bloc.dart';
import '../../history/bloc/get_all_attendances/get_all_attendances_bloc.dart';
import '../bloc/quick_stats_cubit.dart';
import '../bloc/is_checkedin/is_checkedin_bloc.dart';
import '../../../data/model/response/auth_response_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _quickActionPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GetUserBloc>().add(const GetUserEvent.getUser());
    context.read<GetCompanyBloc>().add(const GetCompanyEvent.getCompany());
    context.read<IsCheckedinBloc>().add(const IsCheckedinEvent.isCheckedIn());
    context.read<GetAllAttendancesBloc>().add(
      const GetAllAttendancesEvent.getAllAttendances(),
    );
    context.read<QuickStatsCubit>().fetchStats();
  }

  Future<void> _onRefresh() async {
    context.read<GetUserBloc>().add(const GetUserEvent.getUser());
    context.read<GetCompanyBloc>().add(const GetCompanyEvent.getCompany());
    context.read<IsCheckedinBloc>().add(const IsCheckedinEvent.isCheckedIn());
    context.read<GetAllAttendancesBloc>().add(
      const GetAllAttendancesEvent.getAllAttendances(),
    );
    context.read<QuickStatsCubit>().fetchStats();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: BlocBuilder<GetUserBloc, GetUserState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => _buildTopSection(context, null),
                      success: (authData) =>
                          _buildTopSection(context, authData),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Summary",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      BlocBuilder<GetUserBloc, GetUserState>(
                        builder: (context, userState) {
                          return BlocBuilder<
                            GetAllAttendancesBloc,
                            GetAllAttendancesState
                          >(
                            builder: (context, attState) {
                              String checkIn = '--:--';
                              String checkInStatus = 'No Schedule';
                              Color checkInColor = AppColors.textSecondary;
                              String checkOut = '--:--';
                              String checkOutStatus = '--:--';
                              String workHours = '--:--';
                              String workHoursTotal = '--:--';
                              String overtime = '--:--';
                              String overtimeStatus = '--:--';

                              // Get Schedule
                              String? scheduleJamMasuk;
                              String? scheduleJamKeluar;

                              userState.maybeWhen(
                                success: (authData) {
                                  scheduleJamMasuk =
                                      authData.shiftKerja?.startTime;
                                  scheduleJamKeluar =
                                      authData.shiftKerja?.endTime;
                                },
                                orElse: () {},
                              );

                              if (scheduleJamMasuk != null) {
                                checkInStatus = 'Scheduled $scheduleJamMasuk';
                              }

                              attState.maybeWhen(
                                loaded: (attendances) {
                                  final todayStr = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.now());
                                  final todayAtts = attendances
                                      .where(
                                        (a) =>
                                            a.date != null &&
                                            DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(a.date!) ==
                                                todayStr,
                                      )
                                      .toList();

                                  if (todayAtts.isNotEmpty) {
                                    final todayAtt = todayAtts.first;

                                    checkIn = todayAtt.timeIn ?? '--:--';
                                    checkOut = todayAtt.timeOut ?? '--:--';

                                    // Parse times for logic
                                    DateTime? actIn;
                                    DateTime? actOut;
                                    DateTime? schedIn;
                                    DateTime? schedOut;

                                    try {
                                      if (todayAtt.timeIn != null)
                                        actIn = DateFormat(
                                          'HH:mm:ss',
                                        ).parse(todayAtt.timeIn!);
                                      if (todayAtt.timeOut != null)
                                        actOut = DateFormat(
                                          'HH:mm:ss',
                                        ).parse(todayAtt.timeOut!);
                                      if (scheduleJamMasuk != null)
                                        schedIn = DateFormat(
                                          'HH:mm:ss',
                                        ).parse(scheduleJamMasuk!);
                                      if (scheduleJamKeluar != null)
                                        schedOut = DateFormat(
                                          'HH:mm:ss',
                                        ).parse(scheduleJamKeluar!);
                                    } catch (e) {
                                      try {
                                        if (todayAtt.timeIn != null)
                                          actIn = DateFormat(
                                            'HH:mm',
                                          ).parse(todayAtt.timeIn!);
                                        if (todayAtt.timeOut != null)
                                          actOut = DateFormat(
                                            'HH:mm',
                                          ).parse(todayAtt.timeOut!);
                                        if (scheduleJamMasuk != null)
                                          schedIn = DateFormat(
                                            'HH:mm',
                                          ).parse(scheduleJamMasuk!);
                                        if (scheduleJamKeluar != null)
                                          schedOut = DateFormat(
                                            'HH:mm',
                                          ).parse(scheduleJamKeluar!);
                                      } catch (_) {}
                                    }

                                    if (actIn != null && schedIn != null) {
                                      if (actIn.isAfter(schedIn)) {
                                        checkInStatus = 'Late';
                                        checkInColor = AppColors.warning;
                                      } else {
                                        checkInStatus = 'On Time';
                                        checkInColor = AppColors.success;
                                      }
                                    }

                                    if (actIn != null && actOut != null) {
                                      final diff = actOut.difference(actIn);
                                      final hours = diff.inHours;
                                      final mins = diff.inMinutes % 60;
                                      workHours = '${hours}h ${mins}m';
                                      workHoursTotal = 'Total today';

                                      if (schedOut != null) {
                                        if (actOut.isAfter(schedOut)) {
                                          final otDiff = actOut.difference(
                                            schedOut,
                                          );
                                          final otHours = otDiff.inHours;
                                          final otMins = otDiff.inMinutes % 60;
                                          overtime = '${otHours}h ${otMins}m';
                                          overtimeStatus = 'Pending';
                                        } else {
                                          overtime = '0h 0m';
                                          overtimeStatus = 'No Overtime';
                                        }
                                      }
                                    }
                                  }
                                },
                                loading: () {}, // show defaults
                                orElse: () {},
                              );

                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.55,
                                children: [
                                  _buildSummaryCard(
                                    'Check In',
                                    checkIn,
                                    checkInStatus,
                                    checkInColor,
                                  ),
                                  _buildSummaryCard(
                                    'Check Out',
                                    checkOut,
                                    checkOutStatus,
                                    AppColors.textSecondary,
                                  ),
                                  _buildSummaryCard(
                                    'Work Hours',
                                    workHours,
                                    workHoursTotal,
                                    AppColors.info,
                                  ),
                                  _buildSummaryCard(
                                    'Overtime',
                                    overtime,
                                    overtimeStatus,
                                    AppColors.textSecondary,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Stats',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: BlocBuilder<QuickStatsCubit, QuickStatsState>(
                          builder: (context, state) {
                            if (state is QuickStatsLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is QuickStatsLoaded) {
                              final data = state.data;
                              return Column(
                                children: [
                                  _buildStatRow(
                                    'Attendance Rate',
                                    data.attendanceRate,
                                    LucideIcons.trendingUp,
                                    AppColors.success,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                  _buildStatRow(
                                    'Leave Balance',
                                    data.leaveBalance,
                                    LucideIcons.calendar,
                                    AppColors.info,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                  _buildStatRow(
                                    'Pending Requests',
                                    data.pendingRequests,
                                    LucideIcons.clipboardList,
                                    AppColors.warning,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                                  _buildStatRow(
                                    'Upcoming Holiday',
                                    data.upcomingHoliday,
                                    LucideIcons.zap,
                                    AppColors.purple,
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Material(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.go('/approval'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                LucideIcons.users,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Approval Center',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '4 requests awaiting your review',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              LucideIcons.chevronRight,
                              color: Colors.white.withValues(alpha: 0.50),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Announcements',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'See all',
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ...MockDataSource.announcements.map((a) {
                        Color iconColor;
                        Color bgIconColor;
                        Color tagBgColor;
                        Color tagTextColor;
                        IconData icon;

                        if (a.tag == 'Holiday') {
                          iconColor = AppColors.error;
                          bgIconColor = AppColors.errorBg;
                          tagBgColor = AppColors.errorBg;
                          tagTextColor = AppColors.errorText;
                          icon = LucideIcons.zap;
                        } else if (a.tag == 'Policy') {
                          iconColor = AppColors.info;
                          bgIconColor = AppColors.infoBg;
                          tagBgColor = AppColors.infoBg;
                          tagTextColor = AppColors.infoText;
                          icon = LucideIcons.shield;
                        } else {
                          iconColor = AppColors.purple;
                          bgIconColor = AppColors.purpleBg;
                          tagBgColor = AppColors.purpleBg;
                          tagTextColor = AppColors.purpleText;
                          icon = LucideIcons.barChart2;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: bgIconColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Icon(icon, color: iconColor, size: 19),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tagBgColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        a.tag,
                                        style: TextStyle(
                                          color: tagTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      a.title,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      a.body,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, User? user) {
    const double quickActionHeight = 320;
    const double overlapHeight = 26;

    final name = user?.name ?? 'User';
    final position = user?.position ?? '-';
    final dept = user?.department ?? user?.departemen?.name ?? 'IT';

    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 15) {
      greeting = 'Good Afternoon';
    } else if (hour < 18) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: overlapHeight + 18,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.45),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$position · $dept',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/notifications'),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                LucideIcons.bell,
                                color: Colors.white,
                                size: 24,
                              ),
                              Positioned(
                                top: 10,
                                right: 12,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade400,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            final now = DateTime.now();
                            final dateString = DateFormat(
                              'EEEE, MMMM d, y',
                            ).format(now);
                            final timeString = DateFormat('HH:mm').format(now);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Today',
                                        style: TextStyle(
                                          color: AppColors.primaryLight,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateString,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeString,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 31,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'WIB',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.55,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<IsCheckedinBloc, IsCheckedinState>(
                          builder: (context, state) {
                            final isCheckedin = state.maybeWhen(
                              orElse: () => false,
                              success: (data) => data.isCheckedin,
                            );

                            // For now, check-in time is not provided directly in state,
                            // but we can show status based on isCheckedin
                            final status = isCheckedin ? 'Present' : 'Absent';
                            final checkInTime = isCheckedin ? 'Done' : '--:--';

                            return Row(
                              children: [
                                _buildAttCard('Schedule', '08:00–17:00'),
                                const SizedBox(width: 10),
                                _buildAttCard(
                                  'Status',
                                  status,
                                  highlight: isCheckedin,
                                ),
                                const SizedBox(width: 10),
                                _buildAttCard('Check In', checkInTime),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: quickActionHeight - overlapHeight),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: SizedBox(
            height: quickActionHeight,
            child: _buildQuickActionsCard(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return BlocBuilder<GetCompanyBloc, GetCompanyState>(
      builder: (context, companyState) {
        final attendanceType = companyState
            .maybeWhen(
              success: (data) => data.attendanceType ?? 'hybrid',
              orElse: () => 'hybrid',
            )
            .toLowerCase();

        return BlocBuilder<IsCheckedinBloc, IsCheckedinState>(
          builder: (context, state) {
            final isCheckedin = state.maybeWhen(
              orElse: () => false,
              success: (data) => data.isCheckedin,
            );
            final isCheckout = state.maybeWhen(
              orElse: () => false,
              success: (data) => data.isCheckedout,
            );

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200, // Fixed height for 2 rows of Quick Actions
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _quickActionPage = index;
                        });
                      },
                      children: [
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.15,
                          children: [
                            _buildQuickAction(
                              context,
                              'Check In',
                              LucideIcons.checkCircle,
                              AppColors.success,
                              AppColors.successBg,
                              '/checkin',
                              extra: <String, dynamic>{'isCheckIn': true},
                              disabled: isCheckedin,
                              onTapValidation: () {
                                if (isCheckedin) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Anda sudah Check In hari ini.',
                                      ),
                                    ),
                                  );
                                  return false;
                                }
                                return true;
                              },
                            ),
                            _buildQuickAction(
                              context,
                              'Check Out',
                              LucideIcons.xCircle,
                              AppColors.error,
                              AppColors.errorBg,
                              '/checkin',
                              extra: <String, dynamic>{'isCheckIn': false},
                              disabled: !isCheckedin || isCheckout,
                              onTapValidation: () {
                                if (!isCheckedin) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Anda belum Check In hari ini.',
                                      ),
                                    ),
                                  );
                                  return false;
                                }
                                if (isCheckout) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Anda sudah Check Out hari ini.',
                                      ),
                                    ),
                                  );
                                  return false;
                                }
                                return true;
                              },
                            ),
                            _buildQuickAction(
                              context,
                              'Leave',
                              LucideIcons.fileText,
                              AppColors.info,
                              AppColors.infoBg,
                              '/leave',
                            ),
                            _buildQuickAction(
                              context,
                              'Overtime',
                              LucideIcons.timer,
                              AppColors.warning,
                              AppColors.warningBg,
                              '/overtime',
                            ),
                            _buildQuickAction(
                              context,
                              'Correction',
                              LucideIcons.refreshCw,
                              AppColors.purple,
                              AppColors.purpleBg,
                              '/correction',
                            ),
                            _buildQuickAction(
                              context,
                              'Calendar',
                              LucideIcons.calendar,
                              const Color(0xFF06B6D4),
                              const Color(0xFFECFEFF),
                              '/calendar',
                            ),
                          ],
                        ),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.15,
                          children: [
                            _buildQuickAction(
                              context,
                              'Directory',
                              LucideIcons.contact,
                              const Color(0xFFF97316),
                              const Color(0xFFFFEDD5),
                              '/directory',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _quickActionPage == index ? 16 : 6,
                        decoration: BoxDecoration(
                          color: _quickActionPage == index
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAttCard(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  color: highlight ? const Color(0xFF6EE7B7) : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Color bg,
    String route, {
    Map<String, dynamic>? extra,
    bool disabled = false,
    bool Function()? onTapValidation,
  }) {
    return Material(
      color: disabled ? Colors.grey.shade100 : bg,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                if (onTapValidation != null) {
                  if (!onTapValidation()) return;
                }
                context.push(route, extra: extra);
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: disabled ? Colors.grey : color, size: 26),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                color: disabled ? Colors.grey : color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    String sub,
    Color subColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              // fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: TextStyle(
              color: subColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              // fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
