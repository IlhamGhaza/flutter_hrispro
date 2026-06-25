import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/splash/page/splash_page.dart';
import '../presentation/auth/page/login_page.dart';
import '../presentation/home/page/home_page.dart';
import '../presentation/history/page/history_page.dart';
import '../presentation/notification/page/notifications_page.dart';
import '../presentation/profile/page/profile_page.dart';
import '../presentation/check_in/page/check_in_page.dart';
import '../presentation/leave/page/leave_page.dart';
import '../presentation/overtime/page/overtime_page.dart';
import '../presentation/calendar/page/calendar_page.dart';
import '../presentation/approval/page/approval_page.dart';
import '../presentation/correction/page/correction_page.dart';
import '../presentation/main_layout/widget/main_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
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
      builder: (context, state) => const CheckInPage(),
    ),
    GoRoute(
      path: '/leave',
      builder: (context, state) => const LeavePage(),
    ),
    GoRoute(
      path: '/overtime',
      builder: (context, state) => const OvertimePage(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarPage(),
    ),
    GoRoute(
      path: '/approval',
      builder: (context, state) => const ApprovalPage(),
    ),
    GoRoute(
      path: '/correction',
      builder: (context, state) => const CorrectionPage(),
    ),
  ],
);
