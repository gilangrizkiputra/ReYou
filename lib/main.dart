import 'package:flutter/material.dart';
import 'package:reyou/core/constants/theme.dart';
import 'package:reyou/presentation/routes/app_pages.dart';
import 'package:reyou/presentation/routes/app_routes.dart';

void main() {
  runApp(const ReyouApp());
}

class ReyouApp extends StatelessWidget {
  const ReyouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReYou',
      theme: ThemeData(scaffoldBackgroundColor: lightBackgroundColor),
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}
