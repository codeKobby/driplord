/// Application constants and configuration
///
/// API keys can be provided at build time using --dart-define:
/// flutter run --dart-define=GEMINI_API_KEY=your_key --dart-define=FASHN_API_KEY=your_key
class AppConstants {
  // ==========================================================================
  // Supabase Configuration
  // ==========================================================================
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tkogkivyqvhfijqclwox.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_IJsRSu1TzXmh8YSUVpGrCw_ZgomfCc-',
  );

  // ==========================================================================
  // AI Service API Keys (Required for production)
  // ==========================================================================
  /// Google Gemini API Key for AI features
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Fashn.ai API Key for Virtual Try-On
  static const String fashnApiKey = String.fromEnvironment(
    'FASHN_API_KEY',
    defaultValue: '',
  );

  /// Check if AI services are configured
  static bool get isAiConfigured => geminiApiKey.isNotEmpty;
  static bool get isVtoConfigured => fashnApiKey.isNotEmpty;

  // ==========================================================================
  // Application Identifiers
  // ==========================================================================
  static const String androidPackageName = 'com.poblikio.driplord';
  static const String iosBundleId = 'com.poblikio.driplord';

  // ==========================================================================
  // OAuth Client IDs
  // ==========================================================================
  static const String googleWebClientId =
      '252629221538-pobam808idlc9c76jcmnk5nbrf2q3150.apps.googleusercontent.com';
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
  );
  static const String googleAndroidClientId =
      '252629221538-3036h1mutjneo02jv68bu81snjn15454.apps.googleusercontent.com';

  static const String appleClientId = String.fromEnvironment(
    'APPLE_CLIENT_ID',
    defaultValue: 'YOUR_APPLE_CLIENT_ID',
  );

  static const String supabaseAuthCallbackUrl = String.fromEnvironment(
    'SUPABASE_AUTH_CALLBACK_URL',
    defaultValue: 'io.supabase.driplord://login-callback/',
  );

  // ==========================================================================
  // App Configuration
  // ==========================================================================
  static const String appName = 'DripLord';
  static const String appVersion = '1.0.0';
}
