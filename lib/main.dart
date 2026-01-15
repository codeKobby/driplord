import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/cache_service.dart';
import 'core/services/ai_image_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // Initialize cache service
  await CacheService().initialize();

  // Initialize AI services if configured
  if (AppConstants.isAiConfigured) {
    AiImageService().initialize(AppConstants.geminiApiKey);
    debugPrint('✅ AI Services initialized with Gemini API key.');
  } else {
    debugPrint('⚠️ AI Services not configured. Running in mock mode.');
    debugPrint(
      '   Provide GEMINI_API_KEY via --dart-define to enable AI features.',
    );
  }

  runApp(const ProviderScope(child: DripLordApp()));
}

class DripLordApp extends ConsumerWidget {
  const DripLordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'DripLord',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
