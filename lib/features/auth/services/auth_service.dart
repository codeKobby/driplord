import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../core/constants/app_constants.dart';

class AuthService {
  final SupabaseClient _supabase;
  AuthService(this._supabase);

  Future<AuthResponse> signInWithGoogle() async {
    // Basic verification is fine, but we'll try to sign in regardless since user says it's set up
    if (AppConstants.googleWebClientId.isEmpty) {
      throw 'Google Web Client ID is missing in AppConstants.';
    }

    try {
      // For Android, we only need serverClientId (web client ID)
      // For iOS, we need both clientId and serverClientId
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? AppConstants.googleIosClientId : null,
        serverClientId: AppConstants.googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Sign-in was cancelled.';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'Authentication failed. Please try again.';
      }

      return _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      if (e.toString().contains('ApiException: 10')) {
        throw 'Google Sign-In configuration error. Please verify your SHA-1 fingerprint is registered in Google Cloud Console.';
      }
      if (e.toString().contains('ApiException: 12500')) {
        throw 'Google Sign-In failed. Please check your Google Play Services.';
      }
      rethrow;
    }
  }

  Future<AuthResponse> signInWithApple() async {
    // Apple Sign-In is only available on iOS/macOS
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw 'Apple Sign-In is only available on iOS and macOS devices.';
    }

    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw 'Could not find ID Token from generated credential.';
      }

      return _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
