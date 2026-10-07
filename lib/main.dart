import 'package:flutter/material.dart';
import 'utils/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const SmartRetailApp());
}

class SmartRetailApp extends StatelessWidget {
  const SmartRetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartRetail POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
