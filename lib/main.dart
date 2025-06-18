import 'package:dreamhome_architect/features/signin/signin_screen.dart';
import 'package:dreamhome_architect/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
      url: 'https://cpxhjfjyxmyndupizjhb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNweGhqZmp5eG15bmR1cGl6amhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM1ODM2NDMsImV4cCI6MjA1OTE1OTY0M30.sQMoeiLhTHe1CucwMA8Edk3y2x9YGZV9HJkQkZPsWfU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SigninScreen(),
    );
  }
}
