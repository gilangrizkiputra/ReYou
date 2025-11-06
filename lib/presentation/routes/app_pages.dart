import 'package:flutter/material.dart';
import 'package:reyou/presentation/routes/app_routes.dart';
import 'package:reyou/presentation/screens/home_screen.dart';
import 'package:reyou/presentation/screens/onboarding_screen.dart';
import 'package:reyou/presentation/screens/splash_screen.dart';

final Map<String, WidgetBuilder> appPages = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
};
