import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';
import '../../features/auth/services/auth_service.dart';

/// Provider for the Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for the DatabaseService
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DatabaseService(client);
});

/// Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthService(client);
});

/// Provider for the Auth state
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});
