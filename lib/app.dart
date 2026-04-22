import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/abecedario/screens/abecedario_screen.dart';

class EduKidApp extends StatelessWidget {
  const EduKidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduKid',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AbecedarioScreen(),
    );
  }
}
