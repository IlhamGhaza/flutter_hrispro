import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/router.dart';
import 'core/constant/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'data/datasource/auth_remote_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
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
