import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/welcome/welcome_screen.dart';

class UmeeApp extends StatelessWidget {
  const UmeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umee',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}