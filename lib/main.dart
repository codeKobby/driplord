import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/home/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: DripLordApp()));
}

class DripLordApp extends StatelessWidget {
  const DripLordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DripLord',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/auth/signin': (context) => const AuthScreen(initialIsLogin: true),
        '/auth/signup': (context) => const AuthScreen(initialIsLogin: false),
        '/auth/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
