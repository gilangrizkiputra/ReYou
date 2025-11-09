import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/presentation/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const platform = MethodChannel('app_lock_channel');

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _initPermissionsAndService();
  }

  Future<void> _initPermissionsAndService() async {
    if (!await Permission.systemAlertWindow.isGranted) {
      await openOverlaySettings();
    }

    await openUsageAccessSettings();

    await Future.delayed(const Duration(seconds: 2));

    try {
      await platform.invokeMethod('startService');
      debugPrint("AppMonitorService started successfully");
    } on PlatformException catch (e) {
      debugPrint("Failed to start service: ${e.message}");
    }

    bool seen = await UserPreference.hasSeenOnboarding();
    if (!mounted) return;

    if (seen) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  Future<void> openOverlaySettings() async {
    try {
      await platform.invokeMethod('openOverlaySettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open overlay settings: ${e.message}");
    }
  }

  Future<void> openUsageAccessSettings() async {
    try {
      await platform.invokeMethod('openUsageAccessSettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open usage access settings: ${e.message}");
    }
  }

  void _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 2));
    bool seen = await UserPreference.hasSeenOnboarding();
    if (!mounted) return;

    if (seen) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset('assets/images/img_logo.png', width: 212)],
        ),
      ),
    );
  }
}
