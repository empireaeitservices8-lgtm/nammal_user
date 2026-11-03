import 'package:flutter/material.dart';
import 'core/config/app_theme.dart';
import 'features/auth/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NammalUserApp());
}

class NammalUserApp extends StatelessWidget {
  const NammalUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nammal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
