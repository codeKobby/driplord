/// Application constants and configuration
class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://tkogkivyqvhfijqclwox.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_IJsRSu1TzXmh8YSUVpGrCw_ZgomfCc-';

  // Application Identifiers
  static const String androidPackageName = 'com.poblikio.driplord';
  static const String iosBundleId = 'com.poblikio.driplord';

  // OAuth Client IDs
  // Configured from Google Cloud Console

  // Google OAuth Client IDs
  static const String googleWebClientId = '252629221538-pobam808idlc9c76jcmnk5nbrf2q3150.apps.googleusercontent.com';
  static const String googleIosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com'; // TODO: Create iOS client ID in Google Cloud Console
  static const String googleAndroidClientId = '252629221538-3036h1mutjneo02jv68bu81snjn15454.apps.googleusercontent.com';

  // Apple OAuth Client ID (usually your bundle identifier)
  static const String appleClientId = 'YOUR_APPLE_CLIENT_ID';

  // Supabase OAuth Configuration URLs
  static const String supabaseAuthCallbackUrl = 'YOUR_SUPABASE_AUTH_CALLBACK_URL';

  // App Configuration
  static const String appName = 'DripLord';
  static const String appVersion = '1.0.0';
}
