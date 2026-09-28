import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/router.dart';
import 'core/constant/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'presentation/home/bloc/is_checkedin/is_checkedin_bloc.dart';
import 'presentation/home/bloc/get_company/get_company_bloc.dart';
import 'presentation/profile/bloc/get_user/get_user_bloc.dart';
import 'presentation/profile/bloc/update_user/update_user_bloc.dart';
import 'data/datasource/attendance_remote_datasource.dart';
import 'data/datasource/user_remote_datasource.dart';
import 'data/datasource/leave_remote_datasource.dart';
import 'presentation/leave/bloc/get_all_leaves/get_all_leaves_bloc.dart';
import 'presentation/leave/bloc/create_leave/create_leave_bloc.dart';
import 'presentation/leave/bloc/leave_balance/leave_balance_bloc.dart';
import 'presentation/leave/bloc/leave_type/leave_type_bloc.dart';
import 'presentation/history/bloc/get_all_attendances/get_all_attendances_bloc.dart';
import 'data/datasource/overtime_remote_datasource.dart';
import 'presentation/overtime/bloc/get_overtimes/get_overtimes_bloc.dart';
import 'presentation/overtime/bloc/get_overtime_status/get_overtime_status_bloc.dart';
import 'presentation/overtime/bloc/start_overtime/start_overtime_bloc.dart';
import 'presentation/overtime/bloc/end_overtime/end_overtime_bloc.dart';
import 'presentation/home/bloc/checkin_attendance/checkin_attendance_bloc.dart';
import 'presentation/home/bloc/checkout_attendance/checkout_attendance_bloc.dart';
import 'presentation/home/bloc/today_summary_cubit.dart';
import 'presentation/home/bloc/quick_stats_cubit.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(AuthRemoteDatasource())),
        BlocProvider(create: (context) => LogoutBloc(AuthRemoteDatasource())),
        BlocProvider(
          create: (context) => IsCheckedinBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetCompanyBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(create: (context) => GetUserBloc(UserRemoteDatasource())),
        BlocProvider(
          create: (context) => UpdateUserBloc(UserRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetAllLeavesBloc(LeaveRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CreateLeaveBloc(LeaveRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LeaveBalanceBloc(LeaveRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LeaveTypeBloc(LeaveRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              GetAllAttendancesBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetOvertimesBloc(OvertimeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              GetOvertimeStatusBloc(OvertimeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => StartOvertimeBloc(OvertimeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => EndOvertimeBloc(OvertimeRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CheckinAttendanceBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CheckoutAttendanceBloc(AttendanceRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => TodaySummaryCubit(),
        ),
        BlocProvider(
          create: (context) => QuickStatsCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'HRIS Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
