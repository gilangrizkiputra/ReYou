import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/data/local/user_preference.dart';
import 'package:reyou/presentation/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const platform = MethodChannel('app_lock_channel');
  bool isRequesting = false;

  Future<void> _requestPermissions() async {
    setState(() => isRequesting = true);

    if (!await Permission.systemAlertWindow.isGranted) {
      await _openOverlaySettings();
    }

    await _openUsageAccessSettings();

    setState(() => isRequesting = false);
  }

  Future<void> _openOverlaySettings() async {
    try {
      await platform.invokeMethod('openOverlaySettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open overlay settings: ${e.message}");
    }
  }

  Future<void> _openUsageAccessSettings() async {
    try {
      await platform.invokeMethod('openUsageAccessSettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open usage access settings: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/img_onboarding.png', width: 260, height: 260),
            const SizedBox(height: 20),
            Text(
              "Mengingatkan!",
              style: purpleTextStyle.copyWith(fontSize: 18, fontWeight: bold),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: 'ReYou ',
                style: purpleTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
                children: [
                  TextSpan(
                    text: 'bantu kamu ingatkan hal penting dan bermanfaat',
                    style: blackTextStyle.copyWith(fontSize: 16, fontWeight: regular),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 279,
              height: 51,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  await _requestPermissions();

                  await UserPreference.setOnboardingSeen();
                  if (!mounted) return;

                  try {
                    await platform.invokeMethod('startService');
                    debugPrint("AppMonitorService started successfully");
                  } catch (e) {
                    debugPrint("Failed to start service: $e");
                  }

                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: isRequesting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Mari Mulai",
                        style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: regular),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
