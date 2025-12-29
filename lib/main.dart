import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tkogkivyqvhfijqclwox.supabase.co',
    anonKey: 'sb_publishable_IJsRSu1TzXmh8YSUVpGrCw_ZgomfCc-',
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
      home: const WelcomeScreen(),
    );
  }
}
