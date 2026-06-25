import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constant/colors.dart';
import '../../../data/datasource/auth_local_datasource.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    final isAuth = await AuthLocalDatasource().isAuth();
    if (mounted) {
      if (isAuth) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.fingerprint,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'HRIS Pro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enterprise HR Platform',
              style: TextStyle(
                color: AppColors.primaryLight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'v3.2.1 · 2026 Edition',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PT. Nusantara Teknologi Tbk',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Powered by HRIS Pro Engine',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.15),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
