import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/select_role_screen.dart';
import 'screens/welcome_screen.dart';
import 'models/user_role.dart';

void main() {
  runApp(const HealMateApp());
}

class HealMateApp extends StatelessWidget {
  const HealMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00A8FF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),

      // يبدأ بالـ Splash زي ما انتي عايزة
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/select-role': (_) => const SelectRoleScreen(),
      },

      // هنا بنبني welcome مع الـ role اللي جاي من select role
      onGenerateRoute: (settings) {
        if (settings.name == '/welcome') {
          final role = settings.arguments as UserRole? ?? UserRole.doctor;
          return MaterialPageRoute(
            builder: (_) => WelcomeScreen(role: role),
          );
        }
        return null;
      },
    );
  }
}
