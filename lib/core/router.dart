import 'package:flutter/material.dart';
import 'package:flutter_hrispro/presentation/history/page/history_page.dart';
import 'package:go_router/go_router.dart';

import '../presentation/splash/page/splash_page.dart';
import '../presentation/auth/page/login_page.dart';
import '../presentation/home/page/home_page.dart';
import '../presentation/notification/page/notifications_page.dart';
import '../presentation/profile/page/profile_page.dart';
import '../presentation/check_in/page/check_in_page.dart';
import '../presentation/check_in/page/face_detector_checkin_page.dart';
import '../presentation/check_in/page/attendance_result_page.dart';
import '../presentation/leave/page/leave_page.dart';
import '../presentation/overtime/page/overtime_page.dart';
import '../presentation/calendar/page/calendar_page.dart';
import '../presentation/directory/pages/directory_page.dart';
import '../presentation/approval/page/approval_page.dart';
import '../presentation/correction/page/correction_page.dart';
import '../presentation/main_layout/widget/main_scaffold.dart';
import '../presentation/profile/page/update_profile_page.dart';
import '../presentation/profile/page/notification_settings_page.dart';
import '../presentation/profile/page/app_settings_page.dart';
import '../data/model/response/auth_response_model.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/checkin',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isCheckIn = extra?['isCheckIn'] as bool? ?? true;
        return CheckInPage(isCheckIn: isCheckIn);
      },
      routes: [
        GoRoute(
          path: 'face',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isCheckIn = extra?['isCheckIn'] as bool? ?? true;
            final latitude = extra?['latitude'] as double?;
            final longitude = extra?['longitude'] as double?;
            return FaceDetectorCheckinPage(
              isCheckedIn: isCheckIn,
              latitude: latitude,
              longitude: longitude,
            );
          },
        ),
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final isCheckIn = extra?['isCheckIn'] as bool? ?? true;
            final isMatch = extra?['isMatch'] as bool? ?? true;
            final attendanceType = extra?['attendanceType'] as String? ?? 'hybrid';
            final latitude = extra?['latitude'] as double?;
            final longitude = extra?['longitude'] as double?;
            return AttendanceResultPage(
              isCheckin: isCheckIn,
              isMatch: isMatch,
              attendanceType: attendanceType,
              latitude: latitude,
              longitude: longitude,
            );
          },
        ),
      ],
    ),
    GoRoute(path: '/leave', builder: (context, state) => const LeavePage()),
    GoRoute(
      path: '/overtime',
      builder: (context, state) => const OvertimePage(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarPage(),
    ),
    GoRoute(
      path: '/directory',
      builder: (context, state) => const DirectoryPage(),
    ),
    GoRoute(
      path: '/approval',
      builder: (context, state) => const ApprovalPage(),
    ),
    GoRoute(
      path: '/update-profile',
      builder: (context, state) {
        final user = state.extra as User;
        return UpdateProfilePage(user: user);
      },
    ),
    GoRoute(
      path: '/notification-settings',
      builder: (context, state) => const NotificationSettingsPage(),
    ),
    GoRoute(
      path: '/app-settings',
      builder: (context, state) => const AppSettingsPage(),
    ),
    GoRoute(
      path: '/correction',
      builder: (context, state) => const CorrectionPage(),
    ),
  ],
);
