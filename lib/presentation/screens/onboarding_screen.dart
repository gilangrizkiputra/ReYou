import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/presentation/routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              alignment: Alignment.center,
              image: AssetImage('assets/images/img_onboarding.png'),
              width: 260,
              height: 260,
            ),
            SizedBox(height: 20),
            Text(
              "Mengingatkan!",
              style: purpleTextStyle.copyWith(fontSize: 18, fontWeight: bold),
            ),
            SizedBox(height: 8),
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'ReYou',
                    style: purpleTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  TextSpan(
                    text: ' bantu kamu ingatkan hal\nPenting dan Bermanfaat',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: regular,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 279,
              height: 51,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: Text(
                  "Mari Mulai",
                  style: whiteTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
