import 'package:flutter/material.dart';
import 'package:reyou/presentation/routes/app_routes.dart';
import 'package:reyou/presentation/screens/home_screen.dart';
import 'package:reyou/presentation/screens/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
};
