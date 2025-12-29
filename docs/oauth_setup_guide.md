# OAuth Setup Guide for DripLord

This guide will help you configure Google and Apple Sign-In for your DripLord Flutter application.

## Prerequisites

1. A Supabase project set up and configured
2. Google Cloud Console project
3. Apple Developer Program account (for Apple Sign-In)

## 1. Google Sign-In Setup

### Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API and Google Sign-In API

### Step 2: Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" user type
3. Fill in the required information:
   - App name: DripLord
   - User support email: your-email@example.com
   - Developer contact information

### Step 3: Create OAuth Client IDs

#### Web Client ID (for Supabase)
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Web application"
4. Add authorized redirect URIs:
   - `https://tkogkivyqvhfijqclwox.supabase.co/auth/v1/callback`
5. Save and note the Client ID

#### iOS Client ID
1. Click "Create Credentials" > "OAuth client ID"
2. Choose "iOS"
3. Enter your Bundle ID: `com.poblikio.driplord`
4. Save and note the Client ID
5. **Update the code**: Add this iOS client ID to `lib/core/constants/app_constants.dart` and `ios/Runner/Info.plist`

#### Android Client ID
1. Click "Create Credentials" > "OAuth client ID"
2. Choose "Android"
3. Enter your package name (from `android/app/src/main/AndroidManifest.xml`)
4. Add SHA-1 certificate fingerprint (from your keystore)
5. Save and note the Client ID

### Step 4: Configure Supabase

1. Go to your Supabase dashboard
2. Navigate to Authentication > Providers
3. Enable Google provider
4. Enter your Web Client ID
5. Enable "Skip nonce check" for iOS compatibility

### Step 5: Update App Constants

Edit `lib/core/constants/app_constants.dart`:

```dart
// Replace the placeholder values with your actual client IDs
static const String googleWebClientId = 'your-web-client-id.apps.googleusercontent.com';
static const String googleIosClientId = 'your-ios-client-id.apps.googleusercontent.com';
static const String googleAndroidClientId = 'your-android-client-id.apps.googleusercontent.com';
```

### Step 6: Update iOS Info.plist

Edit `ios/Runner/Info.plist`:

1. Replace `YOUR_WEB_CLIENT_ID_REVERSED` with your reversed web client ID
2. Replace `YOUR_IOS_CLIENT_ID` with your iOS client ID

The reversed client ID is your web client ID with the domain reversed:
- Original: `123456789-abc123def456.apps.googleusercontent.com`
- Reversed: `com.googleusercontent.apps.123456789-abc123def456`

## 2. Apple Sign-In Setup

### Step 1: Enable Apple Sign-In in Your App ID

1. Go to [Apple Developer Console](https://developer.apple.com/)
2. Navigate to Certificates, Identifiers & Profiles
3. Select your App ID
4. Enable "Sign In with Apple"
5. Save changes

### Step 2: Create a Services ID (Optional for web redirect)

If you need web-based Apple Sign-In:

1. Create a new Services ID
2. Enable "Sign In with Apple"
3. Add your domain and return URLs

### Step 3: Configure Supabase

1. Go to your Supabase dashboard
2. Navigate to Authentication > Providers
3. Enable Apple provider
4. Enter your Services ID (if created) or App ID

### Step 4: Update App Constants

Edit `lib/core/constants/app_constants.dart`:

```dart
// Replace with your actual Apple client ID (usually your bundle identifier)
static const String appleClientId = 'com.poblikio.driplord';
```

## 3. Testing

### Android Testing

1. Run the app on an Android device/emulator
2. Try Google Sign-In
3. Check that the OAuth flow completes successfully

### iOS Testing

1. Run the app on an iOS device/simulator
2. Try both Google and Apple Sign-In
3. Verify the Info.plist configurations are correct

## 4. Troubleshooting

### Common Issues

1. **Google Sign-In fails with "ApiException: 10"**
   - Check that your client IDs are correctly configured
   - Verify SHA-1 fingerprint for Android
   - Ensure OAuth consent screen is properly configured

2. **Apple Sign-In fails**
   - Verify your App ID has Sign In with Apple enabled
   - Check that your bundle identifier matches

3. **Supabase authentication errors**
   - Ensure redirect URIs are correctly configured in Supabase
   - Check that providers are enabled in Supabase dashboard

### Debug Tips

- Use Flutter's logging to see detailed error messages
- Check device logs for additional error information
- Verify network connectivity to OAuth providers

## 5. Security Notes

- Never commit actual client IDs to version control
- Use environment variables or secure storage for production
- Regularly rotate your OAuth client secrets
- Enable additional security features in Supabase (RLS, etc.)

## 6. Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Sign In with Apple for Flutter](https://pub.dev/packages/sign_in_with_apple)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Apple Developer Console](https://developer.apple.com/)
